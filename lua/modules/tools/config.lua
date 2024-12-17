-- author: glepnr https://github.com/glepnir
-- date: 2022-07-02
-- License: MIT

local config = {}

function config.devcontainer()
  require('devcontainer').setup({
    -- Can be set to false to prevent generating default commands
    -- Default commands are listed below
    generate_commands = true,
    -- By default no autocommands are generated
    -- This option can be used to configure automatic starting and cleaning of containers
    autocommands = {
      -- can be set to true to automatically start containers when devcontainer.json is available
      init = false,
      -- can be set to true to automatically remove any started containers and any built images when exiting vim
      clean = false,
      -- can be set to true to automatically restart containers when devcontainer.json file is updated
      update = false,
    },
    -- can be changed to increase or decrease logging from library
    log_level = 'info',
    -- can be set to true to disable recursive search
    -- in that case only .devcontainer.json and .devcontainer/devcontainer.json files will be checked relative
    -- to the directory provided by config_search_start
    disable_recursive_config_search = false,
    -- By default all mounts are added (config, data and state)
    -- This can be changed to disable mounts or change their options
    -- This can be useful to mount local configuration
    -- And any other mounts when attaching to containers with this plugin
    attach_mounts = {
      -- Can be set to true to always mount items defined below
      -- And not only when directly attaching
      -- This can be useful if executing attach command separately
      always = true,
      neovim_config = {
        -- enables mounting local config to /root/.config/nvim in container
        enabled = true,
        -- makes mount readonly in container
        options = { 'readonly' },
      },
      neovim_data = {
        -- enables mounting local data to /root/.local/share/nvim in container
        enabled = true,
        -- no options by default
        options = {},
      },
      -- Only useful if using neovim 0.8.0+
      neovim_state = {
        -- enables mounting local state to /root/.local/state/nvim in container
        enabled = true,
        -- no options by default
        options = {},
      },
      -- This takes a list of mounts (strings) that should always be added whenever attaching to containers
      -- This is passed directly as --mount option to docker command
      -- Or multiple --mount options if there are multiple values
      custom_mounts = {},
    },
    -- This takes a list of mounts (strings) that should always be added to every run container
    -- This is passed directly as --mount option to docker command
    -- Or multiple --mount options if there are multiple values
    always_mount = {},
    -- This takes a string (usually either "podman" or "docker") representing container runtime
    -- That is the command that will be invoked for container operations
    -- If it is nil, plugin will use whatever is available (trying "podman" first)
    container_runtime = 'docker',
    -- This takes a string (usually either "podman-compose" or "docker-compose") representing compose command
    -- That is the command that will be invoked for compose operations
    -- If it is nil, plugin will use whatever is available (trying "podman-compose" first)
    compose_command = 'docker-compose',
  })
end

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
