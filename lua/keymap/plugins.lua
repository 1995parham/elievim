local plugin = require('core.pack').register_plugin

plugin({
  'folke/which-key.nvim',
  config = function()
    require('which-key').setup()
  end,
})
