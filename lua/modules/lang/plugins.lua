local conf = require('modules.lang.config')

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = conf.nvim_treesitter,
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    lazy = false,
    dependencies = { 'nvim-treesitter' },
    config = conf.nvim_treesitter_textobjects,
  },

  {
    'davidmh/cspell.nvim',
    -- cspell requires Node.js
    cond = function()
      return require('core.runtime').has_nodejs()
    end,
  },

  {
    'towolf/vim-helm',
  },

  {
    'pearofducks/ansible-vim',
  },

  {
    '1995parham/navi',
    lazy = true,
    ft = 'cheat',
    config = function()
      vim.opt.runtimepath:append(vim.fn.stdpath('data') .. '/lazy/navi/vim')
    end,
  },

  {
    'lervag/vimtex',
    ft = 'tex',
  },

  {
    'Fymyte/rasi.vim',
    ft = 'rasi',
  },
}
