local conf = require('modules.ui.config')

return {
  {
    '1995parham/naz.vim',
    branch = 'main',
    config = conf.naz,
  },

  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = conf.dashboard,
    dependencies = {
      'vim-fugitive',
      'nvim-tree/nvim-web-devicons',
    },
  },

  {
    'nvim-tree/nvim-tree.lua',
    cmd = 'NvimTreeToggle',
    config = conf.nvim_tree,
    dependencies = 'nvim-tree/nvim-web-devicons',
  },

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = conf.lualine,
  },
  -- A neovim lua plugin to help easily manage multiple terminal windows.
  {
    'akinsho/toggleterm.nvim',
    config = conf.tterm,
  },

  {
    'chentoast/marks.nvim',
    event = 'VeryLazy',
    opts = {},
  },
}
