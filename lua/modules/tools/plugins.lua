local conf = require('modules.tools.config')

return {
  {
    'ibhagwan/fzf-lua',
    -- optional for icon support
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
    config = conf.fzf_lua,
  },

  -- wakatime
  {
    'wakatime/vim-wakatime',
  },

  -- Git signs in the gutter, hunk actions, and inline blame (Lua-native replacement for vim-gitgutter)
  {
    'lewis6991/gitsigns.nvim',
    config = conf.gitsigns,
  },
  -- a powerful git log viewer
  { 'cohama/agit.vim' },
  -- fugitive.vim: a git wrapper so awesome, it should be illegal
  { 'tpope/vim-fugitive' },

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

  -- A minimal 🤏 HTTP-client 🐼 interface 🖥️ for Neovim ❤️
  {
    'mistweaverco/kulala.nvim',
    keys = {
      { '<leader>Rs', desc = 'Send request' },
      { '<leader>Ra', desc = 'Send all requests' },
      { '<leader>Rb', desc = 'Open scratchpad' },
    },
    ft = { 'http', 'rest' },
    config = conf.kulala,
  },
}
