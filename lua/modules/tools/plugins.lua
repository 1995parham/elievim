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

  -- a neovim plugin for writing and navigating an Obsidian vault, written in Lua.
  -- this plugin is not meant to replace Obsidian, but to complement it.
  -- My personal workflow involves writing Obsidian notes in Neovim using this plugin,
  -- while viewing and reading them using the Obsidian app.
  {
    'epwalsh/obsidian.nvim',
    event = {
      -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
      -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
      'BufReadPre ~/org/**.md',
      'BufNewFile ~/org/**.md',
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = conf.obsidian,
  },

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
}
