local config = {}

function config.nvim_treesitter()
  -- vim.api.nvim_command('set foldmethod=expr')
  -- vim.api.nvim_command('set foldexpr=nvim_treesitter#foldexpr()')
  require('nvim-treesitter.configs').setup({
    -- Use 'all' to install all parsers (slower startup but maximum coverage)
    -- ensure_installed = 'all',
    -- Curated list based on actual usage for faster startup
    ensure_installed = {
      -- Neovim essentials
      'lua',
      'vim',
      'vimdoc',
      'query',
      -- Main programming languages (based on your file usage)
      'go',
      'python',
      'php',
      'rust',
      'c',
      'cpp',
      -- Web development
      'typescript',
      'tsx',
      'javascript',
      'html',
      'css',
      'scss',
      -- Scripting
      'bash',
      'fish',
      -- Config & data formats
      'json',
      'yaml',
      'toml',
      'xml',
      'ini',
      'csv',
      -- Documentation & markup
      'markdown',
      'markdown_inline',
      'rst',
      -- DevOps & infrastructure
      'dockerfile',
      'helm',
      'terraform',
      'hcl',
      -- Git
      'git_config',
      'git_rebase',
      'gitcommit',
      'gitignore',
      'gitattributes',
      -- Build systems & tools
      'make',
      'cmake',
      'just',
      'ninja',
      -- GraphQL & APIs
      'graphql',
      'http',
      -- Databases
      'sql',
      -- Other useful parsers
      'regex',
      'diff',
      'jq',
      'proto',
      'requirements',
    },
    ignore_install = { 'phpdoc' },
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
end

function config.go_nvim()
  require('go').setup()
end

return config
