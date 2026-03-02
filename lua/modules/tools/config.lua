local config = {}

function config.gitsigns()
  require('gitsigns').setup({
    signs = {
      add = { text = '│' },
      change = { text = '│' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
      untracked = { text = '┆' },
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal({ ']c', bang = true })
        else
          gs.nav_hunk('next')
        end
      end, { desc = 'Next hunk' })

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal({ '[c', bang = true })
        else
          gs.nav_hunk('prev')
        end
      end, { desc = 'Previous hunk' })

      -- Actions
      map('n', '<leader>hs', gs.stage_hunk, { desc = 'Stage hunk' })
      map('n', '<leader>hr', gs.reset_hunk, { desc = 'Reset hunk' })
      map('v', '<leader>hs', function()
        gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, { desc = 'Stage hunk' })
      map('v', '<leader>hr', function()
        gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, { desc = 'Reset hunk' })
      map('n', '<leader>hS', gs.stage_buffer, { desc = 'Stage buffer' })
      map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'Undo stage hunk' })
      map('n', '<leader>hR', gs.reset_buffer, { desc = 'Reset buffer' })
      map('n', '<leader>hp', gs.preview_hunk, { desc = 'Preview hunk' })
      map('n', '<leader>hb', function()
        gs.blame_line({ full = true })
      end, { desc = 'Blame line' })
      map('n', '<leader>hd', gs.diffthis, { desc = 'Diff this' })
      map('n', '<leader>htb', gs.toggle_current_line_blame, { desc = 'Toggle line blame' })
      map('n', '<leader>htd', gs.toggle_deleted, { desc = 'Toggle deleted' })
    end,
  })
end

function config.fzf_lua()
  require('fzf-lua').setup({
    winopts = {
      split = 'belowright new',
    },
  })
end

function config.overseer()
  require('overseer').setup()
end

function config.hardtime()
  require('hardtime').setup({
    disabled_keys = {},
  })
end

function config.kulala()
  require('kulala').setup({
    global_keymaps = {

      ['Open scratchpad'] = {
        '<leader>Rb',
        function()
          require('kulala').scratchpad()
        end,
      },
      ['Open kulala'] = {
        '<leader>Ro',
        function()
          require('kulala').open()
        end,
      },

      ['Toggle headers/body'] = {
        '<leader>Rt',
        function()
          require('kulala').toggle_view()
        end,
        ft = { 'http', 'rest' },
      },
      ['Show stats'] = {
        '<leader>RS',
        function()
          require('kulala').show_stats()
        end,
        ft = { 'http', 'rest' },
      },

      ['Close window'] = {
        '<leader>Rq',
        function()
          require('kulala').close()
        end,
        ft = { 'http', 'rest' },
      },

      ['Copy as cURL'] = {
        '<leader>Rc',
        function()
          require('kulala').copy()
        end,
        ft = { 'http', 'rest' },
      },
      ['Paste from curl'] = {
        '<leader>RC',
        function()
          require('kulala').from_curl()
        end,
        ft = { 'http', 'rest' },
      },

      ['Send request'] = {
        '<leader>Rs',
        function()
          require('kulala').run()
        end,
        mode = { 'n', 'v' },
      },
      ['Send request <cr>'] = {
        '<CR>',
        function()
          require('kulala').run()
        end,
        mode = { 'n', 'v' },
        ft = { 'http', 'rest' },
      },
      ['Send all requests'] = {
        '<leader>Ra',
        function()
          require('kulala').run_all()
        end,
        mode = { 'n', 'v' },
      },

      ['Inspect current request'] = {
        '<leader>Ri',
        function()
          require('kulala').inspect()
        end,
        ft = { 'http', 'rest' },
      },
      ['Replay the last request'] = {
        '<leader>Rr',
        function()
          require('kulala').replay()
        end,
      },

      ['Find request'] = {
        '<leader>Rf',
        function()
          require('kulala').search()
        end,
        ft = { 'http', 'rest' },
      },
      ['Jump to next request'] = {
        '<leader>Rn',
        function()
          require('kulala').jump_next()
        end,
        ft = { 'http', 'rest' },
      },
      ['Jump to previous request'] = {
        '<leader>Rp',
        function()
          require('kulala').jump_prev()
        end,
        ft = { 'http', 'rest' },
      },

      ['Select environment'] = {
        '<leader>Re',
        function()
          require('kulala').set_selected_env()
        end,
        ft = { 'http', 'rest' },
      },
      ['Manage Auth Config'] = {
        '<leader>Ru',
        function()
          require('kulala.ui.auth_manager').open_auth_config()
        end,
        ft = { 'http', 'rest' },
      },
      ['Download GraphQL schema'] = {
        '<leader>Rg',
        function()
          require('kulala').download_graphql_schema()
        end,
        ft = { 'http', 'rest' },
      },

      ['Clear globals'] = {
        '<leader>Rx',
        function()
          require('kulala').scripts_clear_global()
        end,
        ft = { 'http', 'rest' },
      },
      ['Clear cached files'] = {
        '<leader>RX',
        function()
          require('kulala').clear_cached_files()
        end,
        ft = { 'http', 'rest' },
      },
    },
  })
end

return config
