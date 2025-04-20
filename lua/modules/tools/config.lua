local config = {}

function config.fzf_lua()
  require('fzf-lua').setup({
    winopts = {
      split = 'belowright new',
    },
  })
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
          require('lua.kulala.ui.auth_manager').open_auth_config()
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
