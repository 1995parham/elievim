local conf = require('modules.lsp.config')

return {
  {
    'neovim/nvim-lspconfig',

    -- No need to load the plugin—since we just want its configs, adding the
    -- it to the `runtimepath` is enough.
    lazy = true,
    init = function()
      local lspConfigPath = require('lazy.core.config').options.root .. '/nvim-lspconfig'

      -- INFO `prepend` ensures it is loaded before the user's LSP configs, so
      -- that the user's configs override nvim-lspconfig.
      vim.opt.runtimepath:prepend(lspConfigPath)

      conf.init()
    end,
  },

  -- portable package manager for Neovim that runs everywhere Neovim runs.
  -- easily install and manage LSP servers, DAP servers, linters,
  -- and formatters.
  {
    'williamboman/mason.nvim',
    config = conf.mason.setup,
  },

  -- code analysis & navigation plugin
  {
    'ray-x/navigator.lua',
    config = conf.navigator,
    dependencies = {
      { 'ray-x/guihua.lua', build = 'cd lua/fzy && make' },
    },
  },

  -- install and upgrade third party tools automatically
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    config = conf.mason.installer,
  },

  -- extension to mason.nvim that makes it easier
  -- to use lspconfig with mason.nvim
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      'simrat39/rust-tools.nvim',
    },
    config = conf.mason.lspconfig,
  },

  { 'L3MON4D3/LuaSnip', config = conf.lua_snip },

  -- Set of preconfigured snippets for different languages.
  -- https://github.com/rafamadriz/friendly-snippets/wiki
  { 'rafamadriz/friendly-snippets' },

  -- Provides external LTeX file handling
  -- (off-spec lsp) and other functions.
  { 'barreiroleo/ltex_extra.nvim' },

  -- null-ls.nvim reloaded / Use Neovim as a language server to inject LSP diagnostics,
  -- code actions, and more via Lua.
  {
    'nvimtools/none-ls.nvim',
    config = conf.null_ls,
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  {
    'j-hui/fidget.nvim',
    config = conf.progress,
  },

  --  Performant, batteries-included completion plugin for Neovim
  {
    'saghen/blink.cmp',
    version = '1.*',
    dependencies = {
      -- !Important! Make sure you're using the latest release of LuaSnip
      -- `main` does not work at the moment
      { 'L3MON4D3/LuaSnip' },
      -- Bring enjoyment to your auto completion.
      { 'xzbdmw/colorful-menu.nvim' },
      --  vscode-like pictograms for neovim lsp completion items
      { 'onsails/lspkind.nvim' },
    },
    config = conf.cmp,
  },
}
