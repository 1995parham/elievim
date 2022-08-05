-- author: glepnr https://github.com/glepnir
-- date: 2022-07-02
-- License: MIT

local plugin = require('core.pack').register_plugin
local conf = require('modules.tools.config')

plugin({
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope',
  config = conf.telescope,
  requires = {
    'nvim-lua/popup.nvim',
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-file-browser.nvim',
  },
})

-- wakatime
plugin({
  'wakatime/vim-wakatime',
})

-- a vim plugin which shows a git diff in the gutter (sign column) and stages/undoes hunks.
plugin({ 'airblade/vim-gitgutter' })
-- a powerful git log viewer
plugin({ 'cohama/agit.vim' })
-- fugitive.vim: a git wrapper so awesome, it should be illegal
plugin({ 'tpope/vim-fugitive' })

-- quickly insert templates into file
-- plugin({ 'glepnir/template.nvim', config = conf.template })
