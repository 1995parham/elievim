local conf = require('modules.tools.config')

return {
  {
    'nvim-telescope/telescope.nvim',
    config = conf.telescope,
    dependencies = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
    },
  },

  -- wakatime
  {
    'wakatime/vim-wakatime',
  },

  -- a vim plugin which shows a git diff in the gutter (sign column) and stages/undoes hunks.
  { 'airblade/vim-gitgutter' },
  -- a powerful git log viewer
  { 'cohama/agit.vim' },
  -- fugitive.vim: a git wrapper so awesome, it should be illegal
  { 'tpope/vim-fugitive' },

  -- neovim dev container support
  { 'https://codeberg.org/esensar/nvim-dev-container', config = conf.devcontainer },

  -- quickly insert templates into file
  -- plugin({ 'glepnir/template.nvim', config = conf.template })

  -- A task runner and job management plugin for Neovim
  {
    'stevearc/overseer.nvim',
    config = conf.overseer,
  },

  -- A Neovim plugin helping you establish good command workflow and quit bad habit
  {
    'm4xshen/hardtime.nvim',
    dependencies = { 'MunifTanjim/nui.nvim', 'nvim-lua/plenary.nvim' },
    opts = {},
    config = conf.hardtime,
  },

  {
    'easymotion/vim-easymotion',
  },
}
