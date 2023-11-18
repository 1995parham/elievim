-- author: glepnr https://github.com/glepnir
-- date: 2022-07-02
-- License: MIT

local plugin = require('core.pack').register_plugin
local conf = require('modules.tools.config')

plugin({
  'nvim-telescope/telescope.nvim',
  config = conf.telescope,
  requires = {
    'nvim-lua/popup.nvim',
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-file-browser.nvim',
  },
})

-- wakatime
plugin({
  'wakatime/vim-wakatime',
})

-- a vim plugin which shows a git diff in the gutter (sign column) and stages/undoes hunks.
-- plugin({ 'airblade/vim-gitgutter' })
-- a powerful git log viewer
plugin({ 'cohama/agit.vim' })
-- fugitive.vim: a git wrapper so awesome, it should be illegal
plugin({ 'tpope/vim-fugitive' })

-- neovim dev container support
plugin({ 'https://codeberg.org/esensar/nvim-dev-container', config = conf.devcontainer })

-- quickly insert templates into file
-- plugin({ 'glepnir/template.nvim', config = conf.template })

-- a neovim plugin for writing and navigating an Obsidian vault, written in Lua.
-- this plugin is not meant to replace Obsidian, but to complement it.
-- My personal workflow involves writing Obsidian notes in Neovim using this plugin,
-- while viewing and reading them using the Obsidian app.
plugin({
  'epwalsh/obsidian.nvim',
  event = {
    -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
    'BufReadPre ~/org/**.md',
    'BufNewFile ~/org/**.md',
  },
  requires = {
    'nvim-lua/plenary.nvim',
  },
  config = conf.obsidian,
})
