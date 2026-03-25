local config = {}

-- Curated list of parsers to install
local ensure_installed = {
  -- Neovim essentials
  'lua',
  'vim',
  'vimdoc',
  'query',
  -- Main programming languages
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
}

function config.nvim_treesitter()
  require('nvim-treesitter').setup()

  -- Create a user command to install all parsers on demand
  vim.api.nvim_create_user_command('TSInstallAll', function()
    require('nvim-treesitter').install(ensure_installed)
  end, { desc = 'Install all configured treesitter parsers' })

  -- Auto-install all configured parsers (no-op for already installed ones)
  require('nvim-treesitter').install(ensure_installed)

  -- Enable treesitter highlighting and folding for supported filetypes
  vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
      if pcall(vim.treesitter.start, args.buf) then
        vim.api.nvim_set_option_value('foldmethod', 'expr', { scope = 'local' })
        vim.api.nvim_set_option_value('foldexpr', 'v:lua.vim.treesitter.foldexpr()', { scope = 'local' })
      end
    end,
  })
end

function config.nvim_treesitter_textobjects()
  require('nvim-treesitter-textobjects').setup({
    select = {
      lookahead = true,
    },
  })

  -- Textobject keymaps
  local select_textobject = require('nvim-treesitter-textobjects.select').select_textobject
  vim.keymap.set({ 'x', 'o' }, 'af', function()
    select_textobject('@function.outer', 'textobjects')
  end, { desc = 'Select outer function' })
  vim.keymap.set({ 'x', 'o' }, 'if', function()
    select_textobject('@function.inner', 'textobjects')
  end, { desc = 'Select inner function' })
  vim.keymap.set({ 'x', 'o' }, 'ac', function()
    select_textobject('@class.outer', 'textobjects')
  end, { desc = 'Select outer class' })
  vim.keymap.set({ 'x', 'o' }, 'ic', function()
    select_textobject('@class.inner', 'textobjects')
  end, { desc = 'Select inner class' })
end

return config
