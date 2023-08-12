-- author: glepnr https://github.com/glepnir
-- date: 2022-07-02
-- License: MIT
-- recommend some vim mode key defines in this file

local keymap = require('core.keymap')
local nmap, xmap = keymap.nmap, keymap.xmap
local silent, noremap = keymap.silent, keymap.noremap
local opts = keymap.new_opts
local cmd = keymap.cmd

-- Use space as leader key
vim.g.mapleader = ' '

-- leaderkey
nmap({ ' ', '', opts(noremap) })
xmap({ ' ', '', opts(noremap) })

-- noremal remap
nmap({
  -- close buffer
  { '<Leader>bk', cmd('bdelete'), opts(noremap, silent) },
  -- window jump
  { '<C-w>n', cmd('tabnext'), opts(noremap) },
  { '<C-w>p', cmd('tabprevious'), opts(noremap) },
  -- window create
  { '<C-w>c', cmd('tabnew'), opts(noremap) },
  -- find usage
  { '<Leader>fu', vim.lsp.buf.references, opts(noremap, '[f]ind [u]sage') },
  -- save
  -- { '<C-s>', cmd('write'), opts(noremap) },
  -- yank
  -- { 'Y', 'y$', opts(noremap) },
  -- buffer jump
  -- { ']b', cmd('bn'), opts(noremap) },
  -- { '[b', cmd('bp'), opts(noremap) },
  -- remove trailing white space
  { '<Leader>t', cmd('TrimTrailingWhitespace'), opts(noremap) },
  { 'fo', require('obsidian.mapping').gf_passthrough, opts(noremap, '[f]ollow links in obsidian') },
})

-- insert mode
-- imap({
-- { '<C-h>', '<Bs>', opts(noremap) },
-- { '<C-e>', '<End>', opts(noremap) },
-- })

-- commandline remap
-- cmap({ '<C-b>', '<Left>', opts(noremap) })
