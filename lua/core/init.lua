local vim = vim
local vim_path = vim.fn.stdpath('config')
local home = os.getenv('HOME')
local cache_dir = home .. '/.cache/nvim/'
local modules_dir = vim_path .. '/lua/modules'

local plugins = function()
  local list = {
    { import = 'keymap/plugins' },
  }
  local modules = vim.split(vim.fn.globpath(modules_dir, '*/plugins.lua'), '\n')
  for _, f in ipairs(modules) do
    list[#list + 1] = {
      import = string.match(f, 'lua/(.+).lua$'),
    }
  end
  return list
end

-- Create cache dir and subs dir
local createdir = function()
  local data_dir = {
    cache_dir .. 'backup',
    cache_dir .. 'session',
    cache_dir .. 'swap',
    cache_dir .. 'tags',
    cache_dir .. 'undo',
  }
  -- Create directories using Neovim's built-in function
  for _, v in pairs(data_dir) do
    if vim.fn.isdirectory(v) == 0 then
      vim.fn.mkdir(v, 'p')
    end
  end
end

createdir()

-- disable distribution plugins
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1

-- Use space as leader key
vim.g.mapleader = ' '

require('core.options')

if vim.g.neovide then
  require('core.neovide')
end

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require('lazy').setup(plugins())
require('commands')
require('keymap')
