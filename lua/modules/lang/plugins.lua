-- author: glepnr https://github.com/glepnir
-- date: 2022-07-02
-- License: MIT

local plugin = require('core.pack').register_plugin
local conf = require('modules.lang.config')

plugin({
  'nvim-treesitter/nvim-treesitter',
  run = ':TSUpdate',
  after = 'telescope.nvim',
  config = conf.nvim_treesitter,
})

plugin({
  'nvim-treesitter/nvim-treesitter-textobjects',
  after = 'nvim-treesitter',
})

-- A feature-rich Go development plugin, leveraging gopls, treesitter AST, Dap,
-- and various Go tools to enhance the development experience.
-- plugin({
--   'ray-x/go.nvim',
--   config = conf.go_nvim,
--   after = 'nvim-treesitter',
--   requires = {
--     { 'ray-x/guihua.lua', run = 'cd lua/fzy && make' },
--     { 'neovim/nvim-lspconfig' },
--   },
-- })

plugin({
  'towolf/vim-helm',
})

plugin({
  'pearofducks/ansible-vim',
})

plugin({
  'lervag/vimtex',
})

plugin({
  'Fymyte/rasi.vim',
  ft = 'rasi',
})

plugin({
  'fladson/vim-kitty',
})
