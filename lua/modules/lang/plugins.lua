local conf = require('modules.lang.config')

return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = conf.nvim_treesitter,
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = { 'nvim-treesitter' },
  },

  -- A feature-rich Go development plugin, leveraging gopls, treesitter AST, Dap,
  -- and various Go tools to enhance the development experience.
  {
    'ray-x/go.nvim',
    config = conf.go_nvim,
    dependencies = {
      { 'ray-x/guihua.lua', build = 'cd lua/fzy && make' },
    },
  },

  {
    'davidmh/cspell.nvim',
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
