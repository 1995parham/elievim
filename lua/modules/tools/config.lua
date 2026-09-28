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

return config
