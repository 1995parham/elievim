local config = {}

-- config server in this function
function config.init()
  local _lsp = require('modules.lsp.on-attach')

  -- Diagnostic configuration.
  vim.diagnostic.config({
    virtual_text = {
      -- Show severity icons as prefixes.
      prefix = function(diagnostic)
        return _lsp.diagnostic_icons[vim.diagnostic.severity[diagnostic.severity]] .. ' '
      end,
      -- Show only the first line of each diagnostic.
      format = function(diagnostic)
        return vim.split(diagnostic.message, '\n')[1]
      end,
    },
    float = {
      border = 'rounded',
      source = 'if_many',
      -- Show severity icons as prefixes.
      prefix = function(diag)
        local level = vim.diagnostic.severity[diag.severity]
        local prefix = string.format(' %s ', _lsp.diagnostic_icons[level])
        return prefix, 'Diagnostic' .. level:gsub('^%l', string.upper)
      end,
    },
    -- Disable signs in the gutter.
    signs = false,
  })

  for type, icon in pairs(_lsp.diagnostic_icons) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

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
        if string.find(vim.uri_from_bufnr(bufnr), 'nobitex/core') then
          return false
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
  require('fidget').setup({})
end

return config
