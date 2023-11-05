local config = {}

function config.nvim_treesitter()
  -- vim.api.nvim_command('set foldmethod=expr')
  -- vim.api.nvim_command('set foldexpr=nvim_treesitter#foldexpr()')
  require('nvim-treesitter.configs').setup({
    ensure_installed = 'all',
    ignore_install = { 'phpdoc', 'latex', 'fortran' },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { 'markdown' },
    },
    textobjects = {
      select = {
        enable = true,
        keymaps = {
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
    },
  })

  local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()
  parser_configs.just = {
    install_info = {
      url = 'https://github.com/IndianBoy42/tree-sitter-just',
      files = { 'src/parser.c', 'src/scanner.cc' },
      branch = 'main',
      use_makefile = true, -- this may be necessary on MacOS (try if you see compiler errors)
    },
    maintainers = { '@IndianBoy42' },
  }

  if vim.loop.os_uname().sysname == 'Darwin' then
    require('nvim-treesitter.install').compilers = { 'gcc-11' }
  end
end

return config
