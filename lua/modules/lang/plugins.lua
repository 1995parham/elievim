-- author: glepnr https://github.com/glepnir
-- date: 2022-07-02
-- License: MIT

local plugin = require('core.pack').register_plugin
local conf = require('modules.lang.config')

plugin({
  'nvim-treesitter/nvim-treesitter',
  event = 'BufRead',
  run = ':TSUpdate',
  after = 'telescope.nvim',
  config = conf.nvim_treesitter,
})

plugin({
  'nvim-treesitter/nvim-treesitter-textobjects',
  after = 'nvim-treesitter'
})

-- markdown vim mode
plugin({
  'plasticboy/vim-markdown',
  config = function()
    vim.g.vim_markdown_folding_disabled = 1
    vim.g.vim_markdown_math = 1
  end,
  requires = { 'godlygeek/tabular' }
})
