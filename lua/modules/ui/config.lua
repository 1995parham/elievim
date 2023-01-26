-- author: glepnr https://github.com/glepnir
--
-- date: 2022-07-02
-- License: MIT

local config = {}

function config.naz()
  require('naz')
end

function config.galaxyline()
  require('modules.ui.eviline')
end

function config.dashboard()
  local version = vim.version()
  local relationship_start_time = os.time({
    year = 2020,
    month = 2,
    day = 13,
    hour = 22,
    min = 26,
    sec = 0,
  })

  local db = require('dashboard')
  db.setup({
    theme = 'hyper',
    config = {
      header = {
        '▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄',
        '█▀░██▀▄▄▀█▀▄▄▀█░▄▄█▀▄▄▀█░▄▄▀█░▄▄▀█░████░▄▄▀█░▄▀▄░',
        '██░██▄▀▀░█▄▀▀░█▄▄▀█░▀▀░█░▀▀░█░▀▀▄█░▄▄░█░▀▀░█░█▄█░',
        '█▀░▀██▀▀▄██▀▀▄█▀▀▄█░████▄██▄█▄█▄▄█▄██▄█▄██▄█▄███▄',
        '▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀',
        string.format('neovim %d.%d.%d', version.major, version.minor, version.patch),
        vim.fn.strftime('%c') .. ' on ' .. vim.fn.hostname(),
        '',
        '',
      },
      shortcut = {
        { desc = ' Update', group = '@property', action = 'PackerSync', key = 'u' },
        {
          desc = ' Files',
          group = 'Label',
          action = 'Telescope find_files',
          key = 'f',
        },
        {
          desc = ' dotfiles',
          group = 'Number',
          action = 'Telescope find_files cwd=~/dotfiles',
          key = 'd',
        },
        {
          desc = ' neovim',
          group = 'Number',
          action = 'Telescope find_files cwd=~/.config/nvim',
          key = 'n',
        },
      },
      packages = { enable = true },
      project = { limit = 8, action = 'Telescope find_files cwd=' },
      mru = { limit = 10 },
      footer = {
        '',
        string.format('💘 %s', os.date('%H:%M %A %d %B %Y', relationship_start_time)),
        string.format('💞 %d days ago', os.difftime(os.time(), relationship_start_time) / (3600 * 24)),
        '',
      },
    },
  })
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
