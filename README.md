# Introduction

> Based on neovim 0.8.0

## Structure

```text
├── init.lua
├── 📂 lua
│   ├── 📂 core                    heart of elievim which provides api
│   │   ├── init.lua
│   │   ├── keymap.lua             keymap api
│   │   ├── options.lua            vim options
│   │   └── pack.lua               hack packer to load from multiple folders
│   ├── 📂 keymap
│   │   ├── config.lua
│   │   └── init.lua
│   │   └── plugins.lua
│   └── 📂 modules
│       ├── completion
│       │   ├── config.lua
│       │   └── plugins.lua
│       ├── lang
│       │   ├── config.lua
│       │   └── plugins.lua
│       ├── tools
│       │   ├── config.lua
│       │   └── plugins.lua
│       └── ui
│           ├── config.lua
│           ├── eviline.lua
│           └── plugins.lua
└── 📂 snippets                   snippets
    ├── lua.json
    └── package.json

```

## How to register plugins?

API is `require('core.pack').register_plugin`. So pass plugin as param into this
function.

```lua
local plugin = require('core.pack').register_plugin
local conf = require('modules.ui.config')

plugin {'1995parham/naz.vim', config = conf.naz}

plugin {'plugin github repo name'}
```

## what is `config`?

This is a keyword of [packer.nvim](https://github.com/wbthomason/packer.nvim),
you need to check the doc of packer to know how to use packer.
If a plugin has many configs you can create other file in
`modules/your-folder-name/config.lua` avoid
making the `plugins.lua` file too long.

Recommend lazyload plugins. Check the usage in `modules`,
it will improve your neovim
start speed. `lazyload` is not magic, it just generate your config into some `autocmds`,
you can check the
`packer_compiled.lua` to check it.

I don't like the default path config in
packer it use `plugins` folder  So i set
compiled file path to `~/.local/share/nvim/site/lua`, you can find compiled
file in this path. Use `:h autocmd`
to know more about.

When you edit the config and open neovim and it does not take effect. Please try
`PackerCompile` to generate a new compile file with your new change.
You also may encounter errors in this process.

```lua
-- modules/completion/plugins.lua
plugin {'neovim/nvim-lspconfig',
 -- used filetype to lazyload lsp
 -- config your language filetype in here
  ft = { 'lua','rust','c','cpp'},
  config = conf.nvim_lsp,
}

-- modules/tools/plugins.lua
plugin {'nvim-telescope/telescope.nvim',
  -- use command to lazyload.
  cmd = 'Telescope',
  config = conf.telescope,
  requires = {
    {'nvim-lua/popup.nvim', opt = true},
    {'nvim-lua/plenary.nvim',opt = true},
    {'nvim-telescope/telescope-fzy-native.nvim',opt = true},
  }
}
```

## How to config keymap

In cosynvim there are some apis that make it easy to set keymap.
All apis are defined in `core/keymap.lua`.

```lua
-- functions to generate keymap by vim.keymap.set
keymap.nmap()
keymap.imap()
keymap.cmap()
keymap.vmap()
keymap.xmap()
keymap.tmap()
-- generate opts into vim.keymap.set
keymap.new_opts()
-- function type that work with keymap.new_opts
keymap.silent()
keymap.noremap()
keymap.expr()
keymap.nowait()
keymap.remap()
-- just return string with <Cmd> and <CR>
keymap.cmd()
-- work like cmd but for visual map
keymap.cu()
```

Use these apis to config your keymap in `keymap` folder. In this folder
`keymap/init.lua` is necessary but if you
have many vim mode remap you can config them in `keymap/other-file.lua`
in cosynvim is `config.lua` just an
example file.
Then config plugins keymap in `keymap/init.lua`. the example of api usage

```lua
-- genreate keymap in noremal mode
nmap {
  -- packer
  {'<Leader>pu',cmd('PackerUpdate'),opts(noremap,silent,'Packer update')},
  {'<Leader>pi',cmd('PackerInstall'),opts(noremap,silent)},
  {'<Leader>pc',cmd('PackerCompile'),opts(noremap,silent)},
}
```

`map` foreach every table and generate a new table that can pass to
`vim.keymap.set`. `cmd('PackerUpdate')` just
return a string `<cmd>PackerUpdate<CR>` as rhs. lhs is
`<leader>pu>`, `opts(noremap,silent,'Packer update')` generate options table
`{noremap = true,silent = true, desc = 'Packer Update' }`.
for some vim mode remap. not need use `cmd` function. oh maybe you will be
confused what is `<cmd>` check `:h <cmd>` you will get answer

```lua
-- window jump
{"<C-h>",'<C-w>h',opts(noremap)}
```

also you can pass a table not include sub table to `map` like

```lua
nmap {'key','rhs',opts(noremap,silent)}
```

use `:h vim.keymap.set` to know more about.

## LSP Tools Requirements

```sh
- luarocks
- npm / node
- pip / python
```

## Tips

- Improve key repeat

```sh
# mac os need restart
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# linux
xset r rate 210 40
```

## Links
- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_confiurations.md
- 
