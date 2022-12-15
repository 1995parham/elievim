<h1 align="center">The Way of Life</h1>

<h6 align="center">Your editor, your rules</h6>

<p align="center">
  <img src="https://img.shields.io/github/actions/workflow/status/1995parham/elievim/ci.yml?label=ci&logo=github&style=for-the-badge&branch=main" alt="GitHub Workflow Status">
  <img alt="GitHub" src="https://img.shields.io/github/license/1995parham/elievim?logo=gnu&style=for-the-badge">
</p>

# Introduction

> Based on neovim 0.8.0

## Structure

```text
├── init.lua
├── 📂 lua
│   ├── 📂 core                    heart of elievim which provides api
│   │   ├── init.lua
│   │   ├── keymap.lua             keymap api
│   │   ├── options.lua            vim options
│   │   └── pack.lua               hack packer to load from multiple folders
│   │
│   ├── 📂 keymap
│   │   ├── config.lua
│   │   └── init.lua
│   │   └── plugins.lua
│   │
│   ├── 📂 commands
│   │   │
│   │   ├── init.lua
│   │   └── go.lua
│   │   └── ansible.lua
│   │
│   └── 📂 modules
│       │
│       ├── 📂 completion
│       │   ├── config.lua
│       │   └── plugins.lua
│       ├── 📂 lang
│       │   ├── config.lua
│       │   └── plugins.lua
│       ├── 📂 tools
│       │   ├── config.lua
│       │   └── plugins.lua
│       └── 📂 ui
│           ├── config.lua
│           ├── eviline.lua
│           └── plugins.lua
└── 📂 snippets                   snippets
    ├── lua.json
    └── package.json

```

## Nomenclature

_Ellie_ is a pet form of _Elahe_ comming from [Elahe Dastan](https://github.com/elahe-dastan/).

## How to Install?

You need to remove your old configuration and then install `elievim`.

```bash
rm -Rf ~/.config/nvim
rm -Rf ~/.local/share/nvim
rm -Rf ~/.cache/nvim

git clone https://github.com/1995parham/elievim
```

## How to register plugins?

API is `require('core.pack').register_plugin`, So pass plugin as parameter into this
function. Usually this happens in the `plugin.lua` files.

```lua
local plugin = require('core.pack').register_plugin
local conf = require('modules.ui.config')

plugin({'1995parham/naz.vim', config = conf.naz})

plugin({'plugin github repo name'})
```

## What is `config`?

This is a keyword of [packer.nvim](https://github.com/wbthomason/packer.nvim),
you need to check the doc of packer to know how to use packer.
If a plugin has many configs you can create other file in
`modules/your-folder-name/config.lua` avoid
making the `plugins.lua` file too long.

Recommend lazy-load plugins. Check the usage in `modules`,
it will improve your neovim
start speed. `lazyload` is not magic, it just generates your config into some `autocmds`,
you can check the `packer_compiled.lua` to check it.

I don't like the default path config in
packer it uses `plugins` folder, So I set
compiled file path to `~/.local/share/nvim/site/lua`, you can find compiled
file in this path. Use `:h autocmd`
to know more about.

When you edit the config then open neovim, and it does not take effect. Please try
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

## How to config keymap?

In cosynvim there are some apis that make it easy to set keymap.
All APIs are defined in `core/keymap.lua`.

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

Use these APIs to config your keymap in `keymap` folder. In this folder
`keymap/init.lua` is necessary but if you have many VIM modes' remap you can config them in `keymap/other-file.lua`
Then config plugins keymap in `keymap/init.lua`. The example of API usage is as follows:

```lua
-- genreate keymap in noremal mode
nmap {
  -- packer
  {'<Leader>pu',cmd('PackerUpdate'),opts(noremap,silent,'Packer update')},
  {'<Leader>pi',cmd('PackerInstall'),opts(noremap,silent)},
  {'<Leader>pc',cmd('PackerCompile'),opts(noremap,silent)},
}
```

`map` for each every table and generate a new table that can pass to `vim.keymap.set`.

`cmd('PackerUpdate')` just return a string _<cmd>PackerUpdate<CR>_ as RHS.
LHS is `<leader>pu`, `opts(noremap, silent, 'Packer update')` generate options table as follows:

```lua
{noremap = true,silent = true, desc = 'Packer Update' }
```

For some vim mode remap. not need use `cmd` function. Oh! Maybe you will be
confused what is _<cmd>_ check `:h <cmd>` you will get answer.

```lua
-- window jump
{"<C-h>",'<C-w>h',opts(noremap)}
```

Also, you can pass a table not include sub table to `map` like

```lua
nmap {'key','rhs',opts(noremap,silent)}
```

Use `:h vim.keymap.set` to know more about.

## LSP Tools Requirements

For having Language Servers you, at least required following commands:

```bash
- luarocks
- npm / node
- pip / python
```

## Tips

- Improve key repeat

```bash
# mac os need restart
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# linux
xset r rate 210 40
```

## Links

- <https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md>
- <https://github.com/neovim/nvim-lspconfig/wiki>
- <https://github.com/williamboman/mason.nvim/tree/main/lua/mason-registry>
- <https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/MAIN.md>
- <https://neovim.io/doc/user/>

## Languages

I am using `python` and `go` as my primary language so here I documented some useful
features of this configuration in those languages.

### Golang

`FillStruct` is one of my favorite features. In this configuration you can use `spc + c + a`
to see code actions and one of these actions on structs is filling them
[ref](https://github.com/ray-x/go.nvim/blob/master/lua/go/reftool.lua).
