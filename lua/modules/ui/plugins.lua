-- author: glepnr https://github.com/glepnir
-- date: 2022-07-02
-- License: MIT

local plugin = require('core.pack').register_plugin
local conf = require('modules.ui.config')

plugin({
  '1995parham/naz.vim',
  branch = 'main',
  config = conf.naz,
})

plugin({ 'tamton-aquib/duck.nvim' })

plugin({
  'nvimdev/galaxyline.nvim',
  branch = 'main',
  config = conf.galaxyline,
  requires = 'nvim-tree/nvim-web-devicons',
})

plugin({
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  config = conf.dashboard,
  after = 'vim-fugitive',
  requires = { 'nvim-tree/nvim-web-devicons' },
})

plugin({
  'nvim-tree/nvim-tree.lua',
  cmd = 'NvimTreeToggle',
  config = conf.nvim_tree,
  requires = 'nvim-tree/nvim-web-devicons',
})

plugin({
  'akinsho/nvim-bufferline.lua',
  config = conf.nvim_bufferline,
  requires = 'nvim-tree/nvim-web-devicons',
})

-- A neovim lua plugin to help easily manage multiple terminal windows.
plugin({
  'akinsho/toggleterm.nvim',
  config = conf.tterm,
})
