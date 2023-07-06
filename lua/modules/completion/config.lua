-- author: glepnr https://github.com/glepnir
-- date: 2022-07-02
-- License: MIT

local config = {}

-- config server in this function
function config.nvim_lsp()
  vim.diagnostic.config({
    underline = false,
    virtual_text = true,
    signs = true,
    update_in_insert = true,
  })

  local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
  for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end
end

config.navigator = {}

function config.navigator.setup()
  require('navigator').setup({
    default_mapping = false,
    keymaps = {
      -- https://github.com/ray-x/navigator.lua/blob/master/lua/navigator/lspclient/mapping.lua
      {
        key = 'gp',
        mode = 'n',
        func = require('navigator.definition').definition_preview,
        desc = 'LSP: definition [P]review',
      },
      {
        key = '<Space>ca',
        mode = 'v',
        func = require('navigator.codeAction').range_code_action,
        desc = 'LSP: Range [C]ode [A]ction',
      },
      {
        key = '<Space>la',
        mode = 'n',
        func = require('navigator.codelens').run_action,
        desc = 'LSP: Run Code [L]ens [A]ction',
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
  local packages = require('modules.completion.packages')

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
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  local _lsp = require('modules.completion.on-attach')
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  require('mason-lspconfig').setup()
  require('mason-lspconfig').setup_handlers({
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function(server_name) -- default handler (optional)
      require('lspconfig')[server_name].setup({
        on_attach = _lsp.on_attach,
        capabilities = capabilities,
      })
    end,

    ['lua_ls'] = function()
      require('lspconfig').lua_ls.setup(_lsp.lua_ls())
    end,
    ['rust_analyzer'] = function()
      require('rust-tools').setup({})
    end,
    ['ltex'] = function()
      require('lspconfig').ltex.setup(_lsp.ltex_ls())
    end,
    ['gopls'] = function()
      require('lspconfig').gopls.setup(_lsp.gols())
    end,
    ['graphql'] = function()
      require('lspconfig').graphql.setup({})
    end,
    ['dockerls'] = function()
      require('lspconfig').dockerls.setup({})
    end,
    ['docker_compose_language_service'] = function()
      require('lspconfig').docker_compose_language_service.setup(_lsp.docker_compose_language_service())
    end,
  })
end

function config.null_ls()
  local null_ls = require('null-ls')
  local _lsp = require('modules.completion.on-attach')
  local _sources = require('modules.completion.null-ls-sources')

  null_ls.setup({
    -- you can reuse a shared lspconfig on_attach callback here
    on_attach = _lsp.on_attach,
    sources = _sources,
    diagnostics_format = '[#{c}] #{m} (#{s})',
  })
end

function config.cmp()
  local cmp = require('cmp')
  local lspkind = require('lspkind')

  cmp.setup({
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    completion = {
      autocomplete = false,
    },
    view = {
      entries = 'custom',
    },
    mapping = {
      ['<down>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { 'i', 's' }),
      ['<up>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { 'i', 's' }),
      ['<c-space>'] = cmp.mapping(cmp.mapping.complete({}), { 'i' }),
      ['<cr>'] = cmp.mapping(cmp.mapping.confirm({ select = true }), { 's', 'i', 'c' }),
    },
    formatting = {
      format = lspkind.cmp_format({
        -- show only symbol annotations
        mode = 'symbol_text',
        -- prevent the popup from showing more than provided characters
        -- (e.g 50 will not show more than 50 characters)
        maxwidth = 50,
      }),
    },
    window = {},
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
    }, {
      { name = 'buffer' },
    }),
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
    paths = vim.fn.stdpath('config') .. '/snippets',
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
