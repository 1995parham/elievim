-- author: glepnr https://github.com/glepnir
-- date: 2022-07-02
-- License: MIT

local plugin = require('core.pack').register_plugin
local conf = require('modules.completion.config')

-- portable package manager for Neovim that runs everywhere Neovim runs.
-- easily install and manage LSP servers, DAP servers, linters,
-- and formatters.
plugin({
  'williamboman/mason.nvim',
  config = conf.mason,
})

plugin({
  'WhoIsSethDaniel/mason-tool-installer.nvim',
  config = conf.mason_installer,
  requires = { 'williamboman/mason.nvim' },
})

plugin({
  'neovim/nvim-lspconfig',
  -- used filetype to lazyload lsp
  -- config your language filetype in here
  ft = { 'lua', 'rust', 'c', 'cpp', 'go' },
  config = conf.nvim_lsp,
})

plugin({
  'hrsh7th/nvim-cmp',
  event = 'BufReadPre',
  config = conf.nvim_cmp,
  requires = {
    { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-lspconfig' },
    { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
    { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
    { 'saadparwaiz1/cmp_luasnip', after = 'LuaSnip' },
  },
})

plugin({ 'L3MON4D3/LuaSnip', event = 'InsertEnter', config = conf.lua_snip })
