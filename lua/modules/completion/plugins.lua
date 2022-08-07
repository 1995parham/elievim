-- author: glepnr https://github.com/glepnir
-- date: 2022-07-02
-- License: MIT

local plugin = require('core.pack').register_plugin
local conf = require('modules.completion.config')

plugin({
  'neovim/nvim-lspconfig',
  config = conf.nvim_lsp,
})

-- portable package manager for Neovim that runs everywhere Neovim runs.
-- easily install and manage LSP servers, DAP servers, linters,
-- and formatters.
plugin({
  'williamboman/mason.nvim',
  config = conf.mason.setup,
})

-- install and upgrade third party tools automatically
plugin({
  'WhoIsSethDaniel/mason-tool-installer.nvim',
  requires = { 'williamboman/mason.nvim' },
  config = conf.mason.installer,
})

-- extension to mason.nvim that makes it easier
-- to use lspconfig with mason.nvim
plugin({
  'williamboman/mason-lspconfig.nvim',
  requires = {
    'williamboman/mason.nvim',
    'neovim/nvim-lspconfig',
    'hrsh7th/cmp-nvim-lsp',
    'simrat39/rust-tools.nvim',
  },
  after = {
    'nvim-lspconfig',
    'nvim-cmp',
  },
  config = conf.mason.lspconfig,
})

plugin({ 'L3MON4D3/LuaSnip', event = 'InsertEnter', config = conf.lua_snip })

plugin({
  'jose-elias-alvarez/null-ls.nvim',
  config = conf.null_ls,
  requires = { 'nvim-lua/plenary.nvim' },
})

plugin({
  'hrsh7th/nvim-cmp',
  requires = {
    { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-lspconfig' },
    { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
    { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
    { 'saadparwaiz1/cmp_luasnip', after = 'LuaSnip' },
    { 'onsails/lspkind.nvim' },
  },
  after = 'nvim-lspconfig',
  config = conf.cmp,
})
