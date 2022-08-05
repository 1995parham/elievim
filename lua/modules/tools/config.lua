-- author: glepnr https://github.com/glepnir
-- date: 2022-07-02
-- License: MIT

local config = {}

function config.telescope()
  local fb_actions = require('telescope').extensions.file_browser.actions

  require('telescope').setup({
    defaults = {
      prompt_prefix = '> ',
      layout_strategy = 'bottom_pane',
      sorting_strategy = 'ascending',
      -- file_previewer = require('telescope.previewers').vim_buffer_cat.new,
      -- grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
      -- qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
    },
    extensions = {
      file_browser = {
        theme = 'ivy',
        mappings = {
          ['n'] = {
            ['ma'] = fb_actions.create,
            ['mm'] = fb_actions.move,
            ['mr'] = fb_actions.rename,
            ['my'] = fb_actions.copy,
            ['mh'] = fb_actions.toggle_hidden,
          },
        },
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

return config
