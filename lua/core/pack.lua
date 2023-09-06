-- author: glepnr https://github.com/glepnir
-- date: 2022-07-02
-- License: MIT

local fn, uv, api = vim.fn, vim.loop, vim.api
local vim_path = vim.fn.stdpath('config')
local data_dir = string.format('%s/site/', vim.fn.stdpath('data'))
local modules_dir = vim_path .. '/lua/modules'
local packer_compiled = data_dir .. 'lua/packer_compiled.lua'
local packer = nil

local Packer = {}
Packer.__index = Packer

function Packer:load_plugins()
  self.repos = {}

  local get_plugins_list = function()
    local list = {
      'keymap/plugins',
    }
    local tmp = vim.split(fn.globpath(modules_dir, '*/plugins.lua'), '\n')
    for _, f in ipairs(tmp) do
      list[#list + 1] = string.match(f, 'lua/(.+).lua$')
    end
    return list
  end

  local plugins_file = get_plugins_list()
  for _, m in ipairs(plugins_file) do
    require(m)
  end
end

function Packer:load_packer()
  if not packer then
    api.nvim_command('packadd packer.nvim')
    packer = require('packer')
  end
  packer.init({
    compile_path = packer_compiled,
    git = { clone_timeout = 120 },
    disable_commands = true,
    autoremove = false,
    auto_clean = true,
  })
  packer.reset()
  self:load_plugins()
  packer.startup(function(use)
    use({ 'wbthomason/packer.nvim', opt = true })
    for _, repo in ipairs(self.repos) do
      use(repo)
    end
  end)
end

function Packer:init_ensure_plugins()
  local packer_dir = data_dir .. 'pack/packer/opt/packer.nvim'
  local state = uv.fs_stat(packer_dir)
  if not state then
    local cmd = '!git clone https://github.com/wbthomason/packer.nvim ' .. packer_dir
    api.nvim_command(cmd)
    uv.fs_mkdir(data_dir .. 'lua', 511, function()
      assert(true, 'make compile path dir failed')
    end)
  end
  self:load_packer()
  if not state then
    packer.sync()
  end
end

local plugins = setmetatable({}, {
  __index = function(_, key)
    if not packer then
      Packer:load_packer()
    end
    return packer[key]
  end,
})

function plugins.ensure_plugins()
  Packer:init_ensure_plugins()
end

function plugins.register_plugin(repo)
  table.insert(Packer.repos, repo)
end

function plugins.load_compile()
  if vim.fn.filereadable(packer_compiled) == 1 then
    require('packer_compiled')
  else
    vim.notify('Run PackerSync or PackerCompile', vim.log.levels.INFO, { title = 'Packer' })
  end

  local cmds = {
    'Compile',
    'Install',
    'Update',
    'Sync',
    'Clean',
    'Status',
  }
  for _, cmd in ipairs(cmds) do
    api.nvim_create_user_command('Packer' .. cmd, function()
      require('core.pack')[fn.tolower(cmd)]()
    end, {})
  end

  local PackerHooks = vim.api.nvim_create_augroup('PackerHooks', {})

  vim.api.nvim_create_autocmd('User', {
    pattern = 'PackerCompileDone',
    callback = function()
      vim.notify('Compile Done!', vim.log.levels.INFO, { title = 'Packer' })
    end,
    group = PackerHooks,
  })
end

return plugins
