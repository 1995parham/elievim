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
    'mason-org/mason.nvim',
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
    dependencies = { 'mason-org/mason.nvim' },
    config = conf.mason.installer,
  },

  -- extension to mason.nvim that makes it easier
  -- to use lspconfig with mason.nvim
  {
    'mason-org/mason-lspconfig.nvim',
    dependencies = {
      'mason-org/mason.nvim',
    },
    config = conf.mason.lspconfig,
  },

  -- Supercharge your Rust experience in Neovim
  -- Successor to rust-tools.nvim, auto-configures rust-analyzer
  {
    'mrcjkb/rustaceanvim',
    version = '^5',
    lazy = false,
  },

  -- Set of preconfigured snippets for different languages.
  -- https://github.com/rafamadriz/friendly-snippets/wiki
  { 'rafamadriz/friendly-snippets' },

  -- Provides external LTeX file handling
  -- (off-spec lsp) and other functions.
  { 'barreiroleo/ltex_extra.nvim' },

  -- Lightweight yet powerful formatter plugin
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    config = conf.conform,
  },

  -- Asynchronous linter plugin complementing the built-in LSP support
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = conf.lint,
  },

  -- LSP progress notifications
  {
    'j-hui/fidget.nvim',
    event = 'LspAttach',
    config = conf.progress,
  },

  --  Performant, batteries-included completion plugin for Neovim
  {
    'saghen/blink.cmp',
    version = '1.*',
    dependencies = {
      -- Bring enjoyment to your auto completion.
      { 'xzbdmw/colorful-menu.nvim' },
      --  vscode-like pictograms for neovim lsp completion items
      { 'onsails/lspkind.nvim' },
    },
    config = conf.cmp,
  },
}
