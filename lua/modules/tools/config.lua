-- author: glepnr https://github.com/glepnir
-- date: 2022-07-02
-- License: MIT

local config = {}

function config.telescope()
  require('telescope').setup({
    defaults = {
      prompt_prefix = '> ',
      layout_strategy = 'bottom_pane',
      sorting_strategy = 'ascending',
      file_previewer = require('telescope.previewers').cat.new,
      grep_previewer = require('telescope.previewers').cat.new,
      file_ignore_patterns = { '.git/.*', 'lazy-lock.json' },
      -- qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
    },
    extensions = {
      file_browser = {
        theme = 'ivy',
        -- disables netrw and use telescope-file-browser in its place
        hidden = true,
        respect_gitignore = true,
        quiet = true,
      },
    },
  })

  require('telescope').load_extension('file_browser')
end

function config.template()
  local temp = require('template')

  -- template directory
  temp.temp_dir = '~/.config/nvim/templates'
  temp.author = 'Parham Alvani'
  temp.email = 'parham.alvani@gmail.com'
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
