local config = {}

-- Paths/patterns to exclude from format-on-save
local format_exclude_patterns = {
  'nobitex/core',
}

-- config server in this function
function config.init()
  local _lsp = require('modules.lsp.on-attach')

  for type, icon in pairs(_lsp.diagnostic_icons) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  -- Configure LSP file watching to improve detection of new files
  -- This helps LSP servers automatically pick up changes without manual restart
  vim.lsp.set_log_level('warn') -- Reduce log spam

  -- Set up better file watching patterns
  local default_workspace_config = {
    -- Configure workspace folders and file watching
    workspace = {
      -- Maximum number of file changes to monitor (increase if you have large projects)
      didChangeWatchedFiles = {
        dynamicRegistration = true,
        relativePatternSupport = true,
      },
    },
  }

  -- Create user commands for LSP management
  vim.api.nvim_create_user_command('LspRestart', function(opts)
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })

    if opts.bang then
      -- LspRestart! restarts all clients
      clients = vim.lsp.get_clients()
    end

    if #clients == 0 then
      vim.notify('No LSP clients to restart', vim.log.levels.WARN, { title = 'LSP' })
      return
    end

    for _, client in pairs(clients) do
      vim.lsp.stop_client(client.id)
      vim.notify(string.format('Restarting %s...', client.name), vim.log.levels.INFO, { title = 'LSP' })
    end

    vim.defer_fn(function()
      if opts.bang then
        vim.cmd('bufdo edit')
      else
        vim.cmd('edit')
      end
      vim.notify('LSP clients restarted', vim.log.levels.INFO, { title = 'LSP' })
    end, 100)
  end, {
    bang = true,
    desc = 'Restart LSP clients (use ! to restart all)',
  })

  vim.api.nvim_create_user_command('LspInfo', function()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })

    if #clients == 0 then
      vim.notify('No LSP clients attached to this buffer', vim.log.levels.WARN, { title = 'LSP' })
      return
    end

    local lines = { 'LSP Client Information:', '' }
    for _, client in pairs(clients) do
      table.insert(lines, string.format('• %s (id: %d)', client.name, client.id))
      table.insert(lines, string.format('  Status: %s', client.is_stopped() and 'stopped' or 'running'))
      table.insert(lines, string.format('  Root: %s', client.config.root_dir or 'none'))

      if client.workspace_folders then
        table.insert(lines, '  Workspace folders:')
        for _, folder in ipairs(client.workspace_folders) do
          table.insert(lines, string.format('    - %s', folder.name))
        end
      end

      -- Show capabilities
      if client.server_capabilities then
        local caps = {}
        if client.server_capabilities.completionProvider then
          table.insert(caps, 'completion')
        end
        if client.server_capabilities.hoverProvider then
          table.insert(caps, 'hover')
        end
        if client.server_capabilities.definitionProvider then
          table.insert(caps, 'definition')
        end
        if client.server_capabilities.referencesProvider then
          table.insert(caps, 'references')
        end
        if client.server_capabilities.documentFormattingProvider then
          table.insert(caps, 'formatting')
        end
        if #caps > 0 then
          table.insert(lines, string.format('  Capabilities: %s', table.concat(caps, ', ')))
        end
      end
      table.insert(lines, '')
    end

    vim.notify(table.concat(lines, '\n'), vim.log.levels.INFO, { title = 'LSP Info', timeout = 10000 })
  end, {
    desc = 'Show LSP client information',
  })

  vim.api.nvim_create_user_command('LspRefresh', function()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })

    if #clients == 0 then
      vim.notify('No LSP clients attached', vim.log.levels.WARN, { title = 'LSP' })
      return
    end

    for _, client in pairs(clients) do
      -- Clear and refresh diagnostics
      vim.diagnostic.reset(nil, client.id)

      -- Notify the server about workspace changes
      if client.server_capabilities.workspace then
        vim.notify(string.format('Refreshing workspace for %s', client.name), vim.log.levels.INFO, { title = 'LSP' })
      end

      -- Request fresh diagnostics
      vim.lsp.buf_request(bufnr, 'textDocument/diagnostic', {
        textDocument = vim.lsp.util.make_text_document_params(bufnr),
      })
    end

    vim.notify('Workspace refreshed', vim.log.levels.INFO, { title = 'LSP' })
  end, {
    desc = 'Refresh LSP workspace and diagnostics',
  })

  local servers = require('modules.lsp.servers')

  -- A mapping from lsp server name to the executable name
  -- for those servers that are not installed using mason.
  local enabled_lsp_servers = {
    ruff = 'ruff',
    kulala_ls = 'kulala-ls',
  }

  for server_name, lsp_executable in pairs(enabled_lsp_servers) do
    if vim.fn.executable(lsp_executable) == 1 then
      if servers[server_name] then
        vim.lsp.config(server_name, servers[server_name]())
      end
      vim.lsp.enable(server_name)
      -- else
      -- local msg = string.format(
      --   "executable '%s' for server '%s' not found! Server will not be enabled",
      --   lsp_executable,
      --   server_name
      -- )
      -- vim.notify(msg, vim.log.levels.WARN, { title = 'Nvim-config' })
    end
  end
end

function config.navigator()
  require('navigator').setup({
    default_mapping = false,
    ts_fold = {
      enable = true,
    },
    lsp = {
      display_diagnostic_qf = false, -- always show quickfix if there are diagnostic errors, set to false if you want to ignore it
      format_on_save = function(bufnr)
        local uri = vim.uri_from_bufnr(bufnr)
        for _, pattern in ipairs(format_exclude_patterns) do
          if string.find(uri, pattern) then
            return false
          end
        end
        return true
      end,
      hover = {
        enable = true,
      },
      disable_lsp = 'all',
    },
    keymaps = {
      -- https://github.com/ray-x/navigator.lua/blob/master/lua/navigator/lspclient/mapping.lua
      {
        key = 'gp',
        mode = 'n',
        func = require('navigator.definition').definition_preview,
        desc = 'LSP: definition [P]review',
      },
      {
        key = '<Leader>ca',
        mode = 'v',
        func = require('navigator.codeAction').range_code_action,
        desc = 'LSP: Range [C]ode [A]ction',
      },
      {
        key = '<Leader>la',
        mode = 'n',
        func = require('navigator.codelens').run_action,
        desc = 'LSP: Run Code [L]ens [A]ction',
      },
      {
        key = ']r',
        func = require('navigator.treesitter').goto_next_usage,
        desc = 'goto_next_usage',
      },
      {
        key = '[r',
        func = require('navigator.treesitter').goto_previous_usage,
        desc = 'goto_previous_usage',
      },
      {
        key = '<Leader>osl',
        mode = 'n',
        func = require('navigator.symbols').side_panel,
        desc = 'LSP: [O]pen LSP [S]ymbols',
      },
      {
        key = '<Leader>ost',
        mode = 'n',
        func = require('navigator.treesitter').side_panel,
        desc = 'LSP: [O]pen Treesitter [S]ymbols',
      },
    },
  })
end

config.mason = {}

function config.mason.setup()
  require('mason').setup({
    -- The provider implementations to use for resolving package metadata (latest version, available versions, etc.).
    -- Accepts multiple entries, where later entries will be used as fallback should prior providers fail.
    -- Builtin providers are:
    --   - mason.providers.registry-api (default) - uses the https://api.mason-registry.dev API
    --   - mason.providers.client                 - uses only client-side tooling to resolve metadata
    providers = {
      'mason.providers.client',
    },

    pip = {
      -- Whether to upgrade pip to the latest version in the virtual environment before installing packages.
      upgrade_pip = true,

      -- These args will be added to `pip install` calls. Note that setting extra args might impact intended behavior
      -- and is not recommended.
      --
      -- Example: { "--proxy", "https://proxyserver" }
      install_args = {
        '--pre',
      },
    },

    ui = {
      icons = {
        package_installed = '✓',
        package_pending = '➜',
        package_uninstalled = '✗',
      },
    },
  })
end

function config.mason.installer()
  local packages = require('modules.lsp.mason-packages')

  require('mason-tool-installer').setup({
    -- a list of all tools you want to ensure are installed upon
    -- start; they should be the names Mason uses for each tool
    ensure_installed = packages.all(),

    -- if set to true this will check each tool for updates. If updates
    -- are available the tool will be updated. This setting does not
    -- affect :MasonToolsUpdate or :MasonToolsInstall.
    -- Default: false
    auto_update = false,

    -- automatically install / update on startup. If set to false nothing
    -- will happen on startup. You can use :MasonToolsInstall or
    -- :MasonToolsUpdate to install tools and check for updates.
    -- Default: true
    run_on_start = true,

    -- set a delay (in ms) before the installation starts. This is only
    -- effective if run_on_start is set to true.
    -- e.g.: 5000 = 5 second delay, 10000 = 10 second delay, etc...
    -- Default: 0
    start_delay = 3000, -- 3 second delay
  })
end

function config.mason.lspconfig()
  -- https://github.com/williamboman/mason-lspconfig.nvim#configuration
  local servers = require('modules.lsp.servers')

  require('mason-lspconfig').setup({
    automatic_enable = false,
    ensure_installed = {},
  })

  for _, server_name in ipairs(require('mason-lspconfig').get_installed_servers()) do
    if servers[server_name] then
      -- vim.notify(
      --   string.format('lsp client %s registered with custom configuration in mason-lspconfig', server_name),
      --   vim.log.levels.DEBUG,
      --   {
      --     title = 'elievim',
      --   }
      -- )
      vim.lsp.config(server_name, servers[server_name]())
    end

    vim.lsp.enable(server_name)
  end
end

function config.null_ls()
  local null_ls = require('null-ls')
  local _sources = require('modules.lsp.null-ls-sources')

  null_ls.setup({
    sources = _sources,
    diagnostics_format = '[#{c}] #{m} (#{s})',
  })
end

function config.cmp()
  require('blink.cmp').setup({
    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
    -- 'super-tab' for mappings similar to vscode (tab to accept)
    -- 'enter' for enter to accept 'none' for no mappings
    --
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = { preset = 'enter' },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
    },

    snippets = { preset = 'luasnip' },

    completion = {
      menu = {
        draw = {
          -- We don't need label_description now because label and label_description are already
          -- combined together in label by colorful-menu.nvim.
          columns = { { 'kind_icon' }, { 'label', gap = 1 } },
          components = {
            label = {
              text = function(ctx)
                return require('colorful-menu').blink_components_text(ctx)
              end,
              highlight = function(ctx)
                return require('colorful-menu').blink_components_highlight(ctx)
              end,
            },
            kind_icon = {
              text = function(ctx)
                local icon = ctx.kind_icon
                if vim.tbl_contains({ 'Path' }, ctx.source_name) then
                  local dev_icon, _ = require('nvim-web-devicons').get_icon(ctx.label)
                  if dev_icon then
                    icon = dev_icon
                  end
                else
                  icon = require('lspkind').symbolic(ctx.kind, {
                    mode = 'symbol',
                  })
                end

                return icon .. ctx.icon_gap
              end,
              -- Optionally, use the highlight groups from nvim-web-devicons
              -- You can also add the same function for `kind.highlight` if you want to
              -- keep the highlight groups in sync with the icons.
              highlight = function(ctx)
                local hl = ctx.kind_hl
                if vim.tbl_contains({ 'Path' }, ctx.source_name) then
                  local dev_icon, dev_hl = require('nvim-web-devicons').get_icon(ctx.label)
                  if dev_icon then
                    hl = dev_hl
                  end
                end
                return hl
              end,
            },
          },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
      },
    },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },

    -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = { implementation = 'prefer_rust_with_warning' },
  })
end

function config.lua_snip()
  local ls = require('luasnip')
  local types = require('luasnip.util.types')
  ls.config.set_config({
    history = true,
    enable_autosnippets = true,
    updateevents = 'TextChanged,TextChangedI',
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { '<- choiceNode', 'Comment' } },
        },
      },
    },
  })

  ls.filetype_extend('yaml', { 'kubernetes' })
  ls.filetype_extend('python', { 'django' })

  require('luasnip.loaders.from_lua').lazy_load({
    paths = { vim.fn.stdpath('config') .. '/snippets' },
  })
  require('luasnip.loaders.from_vscode').lazy_load()
  require('luasnip.loaders.from_vscode').lazy_load({
    paths = vim.fn.stdpath('config') .. '/snippets',
  })
end

function config.progress()
  require('fidget').setup({
    progress = {
      poll_rate = 0.5, -- How frequently to poll for progress messages
      suppress_on_insert = false, -- Suppress new messages while in insert mode
      ignore_done_already = false, -- Ignore new tasks that are already complete
      ignore_empty_message = false, -- Ignore new tasks that don't contain a message
      clear_on_detach = function(client_id)
        local client = vim.lsp.get_client_by_id(client_id)
        return client and client.name or nil
      end,
      notification_group = function(msg)
        return msg.lsp_client.name
      end,
      ignore = {}, -- List of LSP servers to ignore
      display = {
        render_limit = 16, -- How many LSP messages to show at once
        done_ttl = 3, -- How long a message should persist after completion
        done_icon = '✔', -- Icon shown when a task completes
        done_style = 'Constant', -- Highlight group for completed tasks
        progress_ttl = math.huge, -- How long a message should persist when in progress
        progress_icon = { pattern = 'dots', period = 1 }, -- Icon shown during progress
        progress_style = 'WarningMsg', -- Highlight group for in-progress tasks
        group_style = 'Title', -- Highlight group for group name
        icon_style = 'Question', -- Highlight group for the icon
        priority = 30, -- Ordering priority for LSP notification group
        skip_history = true, -- Don't add to notification history
        format_message = require('fidget.progress.display').default_format_message,
        format_annote = function(msg)
          return msg.title
        end,
        format_group_name = function(group)
          return tostring(group)
        end,
        overrides = {
          rust_analyzer = { name = 'rust-analyzer' },
        },
      },
      lsp = {
        progress_ringbuf_size = 0, -- Configure the nvim's LSP progress ring buffer size
      },
    },
    notification = {
      poll_rate = 10, -- How frequently to update and render notifications
      filter = vim.log.levels.INFO, -- Minimum notifications level
      history_size = 128, -- Number of removed messages to retain in history
      override_vim_notify = false, -- Let nvim-notify handle vim.notify
      configs = { default = require('fidget.notification').default_config },
      redirect = function(msg, level, opts)
        if opts and opts.on_open then
          return require('fidget.integration.nvim-notify').delegate(msg, level, opts)
        end
      end,
      view = {
        stack_upwards = true, -- Display notification items from bottom to top
        icon_separator = ' ', -- Separator between group name and icon
        group_separator = '---', -- Separator between notification groups
        group_separator_hl = 'Comment',
      },
      window = {
        normal_hl = 'Comment', -- Base highlight group in the notification window
        winblend = 0, -- Background color opacity
        border = 'none', -- Border style
        zindex = 45, -- Stacking priority
        max_width = 0, -- Maximum width (0 means no limit)
        max_height = 0, -- Maximum height (0 means no limit)
        x_padding = 1, -- Padding from right edge
        y_padding = 0, -- Padding from bottom edge
        align = 'bottom', -- How to align the notification window
        relative = 'editor', -- What the notification window position is relative to
      },
    },
  })
end

return config
