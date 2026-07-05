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
  -- Single tabpage interface for cycling through diffs and git log
  { 'sindrets/diffview.nvim' },
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
    build = function()
      -- Set up everything kulala needs at install/update time (synchronously),
      -- so nothing downloads or builds lazily mid-session. Version-aware: a
      -- :Lazy update re-runs this whenever the backend/grammar versions bump.
      local Globals = require('kulala.globals')
      local data = vim.fn.stdpath('data')

      local function run(cmd, err)
        vim.fn.system(cmd)
        if vim.v.shell_error ~= 0 then error(err .. ' (exit ' .. vim.v.shell_error .. ')') end
      end

      -- 1. kulala-core backend binary --------------------------------------
      local uname = vim.uv.os_uname()
      local os_name = ({ Darwin = 'darwin', Windows_NT = 'windows' })[uname.sysname] or 'linux'
      local arch = uname.machine
      if arch == 'x86_64' or arch == 'AMD64' then
        arch = 'x86_64'
      elseif arch == 'aarch64' or arch == 'ARM64' then
        arch = os_name == 'linux' and 'aarch64' or 'arm64'
      end
      local bin = 'kulala-core-' .. os_name .. '-' .. arch .. (os_name == 'windows' and '.exe' or '')
      local bin_dir = data .. '/kulala.nvim/bin'
      vim.fn.mkdir(bin_dir, 'p')
      local bin_out = bin_dir .. '/kulala-core'
      run({ 'curl', '-fL', '-o', bin_out, string.format(
        'https://github.com/mistweaverco/kulala-core/releases/download/v%s/%s', Globals.BACKEND_VERSION, bin
      ) }, 'kulala: failed to download kulala-core')
      vim.fn.system({ 'chmod', '+x', bin_out })

      -- 2. tree-sitter grammar repo ----------------------------------------
      local src = data .. '/kulala.nvim/tree-sitter-kulala-http'
      vim.fn.mkdir(src, 'p')
      if vim.fn.isdirectory(src .. '/.git') == 0 then
        run({ 'git', '-C', src, 'init', '--quiet' }, 'kulala: git init failed')
      end
      -- Self-heal a missing/incorrect origin (the state that broke fetching).
      if vim.fn.system({ 'git', '-C', src, 'remote' }):find('origin') then
        run({ 'git', '-C', src, 'remote', 'set-url', 'origin', Globals.TREESITTER_REPO_URL }, 'kulala: git remote set-url failed')
      else
        run({ 'git', '-C', src, 'remote', 'add', 'origin', Globals.TREESITTER_REPO_URL }, 'kulala: git remote add failed')
      end
      run({ 'git', '-C', src, 'fetch', '--depth', '1', 'origin', Globals.TREESITTER_VERSION }, 'kulala: grammar fetch failed')
      run({ 'git', '-C', src, 'checkout', '--quiet', 'FETCH_HEAD' }, 'kulala: grammar checkout failed')

      -- 3. build parser + sync queries into the site dir -------------------
      local ext = vim.fn.has('win32') == 1 and 'dll' or (vim.fn.has('macunix') == 1 and 'dylib' or 'so')
      local parser_dir = data .. '/site/parser'
      local query_dir = data .. '/site/queries/kulala_http'
      vim.fn.mkdir(parser_dir, 'p')
      vim.fn.mkdir(query_dir, 'p')
      run({ 'tree-sitter', 'build', '-o', parser_dir .. '/kulala_http.' .. ext, src },
        'kulala: tree-sitter build failed (is the tree-sitter CLI installed?)')
      for _, scm in ipairs(vim.fn.glob(src .. '/queries/kulala_http/*.scm', false, true)) do
        vim.fn.system({ 'cp', '-f', scm, query_dir })
      end
    end,
    config = conf.kulala,
  },
}
