local conf = require('modules.lang.config')

return {
  {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    after = 'telescope.nvim',
    config = conf.nvim_treesitter,
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  },

  -- A feature-rich Go development plugin, leveraging gopls, treesitter AST, Dap,
  -- and various Go tools to enhance the development experience.
  {
    'ray-x/go.nvim',
    config = conf.go_nvim,
    after = 'nvim-treesitter',
    requires = {
      { 'ray-x/guihua.lua', run = 'cd lua/fzy && make' },
      { 'neovim/nvim-lspconfig' },
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
    'lervag/vimtex',
  },

  {
    'Fymyte/rasi.vim',
    ft = 'rasi',
  },

  {
    'fladson/vim-kitty',
  },
}
