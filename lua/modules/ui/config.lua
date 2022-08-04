-- author: glepnr https://github.com/glepnir
--
-- date: 2022-07-02
-- License: MIT

local config = {}

function config.naz()
  require('colorbuddy').colorscheme('naz')
end

function config.galaxyline()
  require('modules.ui.eviline')
end

function config.dashboard()
  local home = os.getenv('HOME')
  local db = require('dashboard')
  local version = vim.version()
  local relationship_start_time = os.time({
    year = 2020,
    month = 2,
    day = 13,
    hour = 22,
    min = 26,
    sec = 0,
  })

  db.session_directory = home .. '/.cache/nvim/session'
  db.custom_header = {
    '▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄',
    '█▀░██▀▄▄▀█▀▄▄▀█░▄▄█▀▄▄▀█░▄▄▀█░▄▄▀█░████░▄▄▀█░▄▀▄░',
    '██░██▄▀▀░█▄▀▀░█▄▄▀█░▀▀░█░▀▀░█░▀▀▄█░▄▄░█░▀▀░█░█▄█░',
    '█▀░▀██▀▀▄██▀▀▄█▀▀▄█░████▄██▄█▄█▄▄█▄██▄█▄██▄█▄███▄',
    '▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀',
    string.format('neovim %d.%d.%d', version.major, version.minor, version.patch),
    vim.fn.strftime('%c') .. ' on ' .. vim.fn.hostname(),
    '',
    '',
  }
  db.custom_center = {
    {
      icon = '  ',
      desc = 'Update Plugins                          ',
      shortcut = 'SPC p u',
      action = 'PackerUpdate',
    },
    {
      icon = '  ',
      desc = 'Find  File                              ',
      action = 'Telescope find_files find_command=rg,--hidden,--files',
      shortcut = 'SPC f f',
    },
  }
  db.custom_footer = {
    '',
    string.format('💘 %s', os.date('%H:%M %A %d %B %Y', relationship_start_time)),
    string.format('💞 %d days ago', os.difftime(os.time(), relationship_start_time) / (3600 * 24)),
    '',
  }
  if packer_plugins ~= nil then
    local count = #vim.tbl_keys(packer_plugins)
    table.insert(db.custom_footer, string.format('🎉 neovim loaded %d plugins', count))
  end
end

function config.nvim_bufferline()
  require('bufferline').setup({
    options = {
      modified_icon = '✥',
      buffer_close_icon = '',
      always_show_bufferline = false,
    },
  })
end

function config.nvim_tree()
  require('nvim-tree').setup({
    disable_netrw = false,
    hijack_cursor = true,
    hijack_netrw = true,
  })
end

function config.fterm()
  local fterm = require('FTerm')

  local lazydocker = fterm:new({
    ft = 'fterm_lazydocker',
    cmd = 'lazydocker',
    dimensions = {
      height = 0.8,
      width = 0.8,
      x = 0.5,
      y = 0.5,
    },
  })

  local ipython = fterm:new({
    ft = 'fterm_ipython',
    cmd = 'ipython',
    dimensions = {
      height = 0.8,
      width = 0.8,
      x = 0.5,
      y = 0.5,
    },
  })

  vim.api.nvim_create_user_command('FTermToggle', fterm.toggle, { bang = true })
  vim.api.nvim_create_user_command('LDToggle', function()
    lazydocker:toggle()
  end, { bang = true })
  vim.api.nvim_create_user_command('IPToggle', function()
    ipython:toggle()
  end, { bang = true })
end

return config
