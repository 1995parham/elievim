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

plugin({ 'glepnir/dashboard-nvim', config = conf.dashboard })

plugin({
  'glepnir/galaxyline.nvim',
  branch = 'main',
  config = conf.galaxyline,
  requires = 'kyazdani42/nvim-web-devicons',
})

plugin({
  'kyazdani42/nvim-tree.lua',
  cmd = 'NvimTreeToggle',
  config = conf.nvim_tree,
  requires = 'kyazdani42/nvim-web-devicons',
})

plugin({
  'akinsho/nvim-bufferline.lua',
  config = conf.nvim_bufferline,
  requires = 'kyazdani42/nvim-web-devicons',
})

-- No-nonsense floating terminal plugin for neovim
plugin({
  'numToStr/FTerm.nvim',
  config = conf.fterm,
})
