local config = {}

function config.fzf_lua()
  require('fzf-lua').setup{
    winopts = {
      split = 'belowright new',
    },
  }
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
