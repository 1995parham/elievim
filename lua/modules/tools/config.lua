-- author: glepnr https://github.com/glepnir
-- date: 2022-07-02
-- License: MIT

local config = {}

function config.telescope()
  if not packer_plugins['plenary.nvim'].loaded then
    vim.cmd([[packadd plenary.nvim]])
    vim.cmd([[packadd popup.nvim]])
    vim.cmd([[packadd telescope-file-browser.nvim]])
  end
  require('telescope').load_extension('file_browser')

  local fb_actions = require("telescope").extensions.file_browser.actions

  require('telescope').setup({
    defaults = {
      layout_config = {
        horizontal = { prompt_position = 'top', results_width = 0.6 },
        vertical = { mirror = false },
      },
      sorting_strategy = 'ascending',
      file_previewer = require('telescope.previewers').vim_buffer_cat.new,
      grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
      qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
    },
    extensions = {
      file_browser = {
        theme = 'ivy',
        mapping = {
          ["n"] = {
            ["ma"] = fb_actions.create,
            ["mm"] = fb_actions.move,
            ["mr"] = fb_actions.rename,
            ["my"] = fb_actions.copy,
            ["mh"] = fb_actions.toggle_hidden,
          },
        },
      },
    },
  })
end

return config
