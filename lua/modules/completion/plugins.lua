local conf = require('modules.completion.config')

return {
  {
    'neovim/nvim-lspconfig',
    config = conf.nvim_lsp,
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
      { 'ray-x/guihua.lua',     build = 'cd lua/fzy && make' },
      { 'neovim/nvim-lspconfig' },
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
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
      'simrat39/rust-tools.nvim',
    },
    config = conf.mason.lspconfig,
  },

  { 'L3MON4D3/LuaSnip',            config = conf.lua_snip },

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
    'nvimtools/none-ls.nvim',
    dependencies = {
      'nvimtools/none-ls-extras.nvim',
    },
  },

  {
    'j-hui/fidget.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
    },
    config = conf.progress,
  },

  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp',     dependencies = { 'nvim-lspconfig' } },
      { 'hrsh7th/cmp-path',         dependencies = { 'nvim-cmp' } },
      { 'hrsh7th/cmp-buffer',       dependencies = { 'nvim-cmp' } },
      { 'saadparwaiz1/cmp_luasnip', dependencies = { 'LuaSnip' } },
      { 'onsails/lspkind.nvim' },
    },
    config = conf.cmp,
  },
}
