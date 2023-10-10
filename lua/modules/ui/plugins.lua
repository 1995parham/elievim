local plugin = require('core.pack').register_plugin
local conf = require('modules.ui.config')

plugin({
  '1995parham/naz.vim',
  branch = 'main',
  config = conf.naz,
})

plugin({ 'tamton-aquib/duck.nvim' })

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
  'nvim-lualine/lualine.nvim',
  requires = { 'nvim-tree/nvim-web-devicons', opt = true },
  config = conf.lualine,
})

-- A neovim lua plugin to help easily manage multiple terminal windows.
plugin({
  'akinsho/toggleterm.nvim',
  config = conf.tterm,
})

--  UI Component Library for Neovim.
plugin({
  'MunifTanjim/nui.nvim',
})

-- 💥 Highly experimental plugin that completely replaces the UI for messages,
-- cmdline and the popupmenu.
plugin({
  'folke/noice.nvim',
  config = conf.noice,
  requires = {
    { 'MunifTanjim/nui.nvim' },
    { 'rcarriga/nvim-notify', opt = true },
  },
})
