<h1 align="center">The Way of Life</h1>

<h6 align="center">Your editor, your rules</h6>

<p align="center">
  <img src="https://github.com/elahe-dastan.png" alt="Elahe"><br>
  <img src="https://img.shields.io/github/actions/workflow/status/1995parham/elievim/ci.yml?label=ci&logo=github&style=for-the-badge&branch=main" alt="GitHub Workflow Status">
  <img alt="GitHub" src="https://img.shields.io/github/license/1995parham/elievim?logo=gnu&style=for-the-badge">
</p>

# Introduction

Neovim is a modern and powerful text editor that is fully compatible with Vim and supports Lua plugins,
LSP client, and remote plugins. It is a project that seeks to aggressively refactor Vim in order to simplify maintenance,
enable advanced UIs, and maximize extensibility.
You can learn more about Neovim from its [official website](https://neovim.io/),
its [GitHub repository](https://github.com/neovim/neovim), or its [releases page](https://github.com/neovim/neovim/releases).

## Structure

```text
├── init.lua
├── 📂 lua
│   ├── 📂 core                    heart of elievim which provides api
│   │   ├── init.lua
│   │   ├── keymap.lua             keymap api
│   │   └── options.lua            vim options
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
│           └── plugins.lua
└── 📂 snippets                   snippets
    ├── lua.json
    └── package.json

```

## Nomenclature

_Ellie_ is a pet form of _Elahe_ coming from [Elahe Dastan](https://github.com/elahe-dastan/).

## How to Install?

You need to remove your old configuration and then install `elievim` using:

```bash
rm -Rf ~/.config/nvim
rm -Rf ~/.local/share/nvim
rm -Rf ~/.cache/nvim

git clone https://github.com/1995parham/elievim
```

## How to register plugins?

When you have a new module in the `modules` folder, you can register plugins as follows in the `plugins.lua`:

```lua
local conf = require('modules.ui.config')

return {
    {'1995parham/naz.vim', config = conf.naz},
    {'plugin github repo name'},
}
```

## What is `config`?

This is a keyword of [lazy.nvim](https://github.com/folke/lazy.nvim),
and you need to check its document.
If a plugin has many configs you can create other file in
`modules/your-folder-name/config.lua` and avoid making the `plugins.lua` file too long.

Recommend lazy-load plugins. Check the usage in `modules`,
it will improve your neovim
start speed. `lazy load` is not magic, it just generates your config into some `autocmds`,
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
 -- used filetype to lazy load lsp
 -- config your language filetype in here
  ft = { 'lua','rust','c','cpp'},
  config = conf.nvim_lsp,
}

-- modules/tools/plugins.lua
plugin {'nvim-telescope/telescope.nvim',
  -- use command to lazy load.
  cmd = 'Telescope',
  config = conf.telescope,
  requires = {
    {'nvim-lua/popup.nvim', opt = true},
    {'nvim-lua/plenary.nvim',opt = true},
    {'nvim-telescope/telescope-fzy-native.nvim',opt = true},
  }
}
```

## How to config key mapping?

In elievim there are some APIs that make it easy to set key mapping.
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
-- genreate keymap in normal mode
nmap {
  -- packer
  {'<Leader>pu',cmd('PackerUpdate'),opts(noremap,silent,'Packer update')},
  {'<Leader>pi',cmd('PackerInstall'),opts(noremap,silent)},
  {'<Leader>pc',cmd('PackerCompile'),opts(noremap,silent)},
}
```

`map` for each table, generate a new table that can pass to `vim.keymap.set` as follows:

> `cmd('PackerUpdate')` just return a string `<cmd>PackerUpdate<CR>` as RHS.
> LHS is `<leader>pu` and `opts(noremap, silent, 'Packer update')` generate options table as follows:

```lua
{noremap = true,silent = true, desc = 'Packer Update' }
```

For some vim mode remap and Do not need use `cmd` function because
you want to have another keymap not a command as RHS.

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

For having Language Servers, at least required following commands:

```bash
- luarocks
- npm / node
- pip / python
```

### Configuration

Language servers are configured in `lua/modules/completion/config.lua` based on
[`nvim-lspconfig`](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md).

You need to install them using [`mason.nvim`](https://github.com/williamboman/mason.nvim) and if they
are not defined in [`mason-lspconfig.nvim`](https://github.com/williamboman/mason-lspconfig.nvim) or you want to configure them
manually, then you need to configure them in `lua/modules/completion/config.lua` like follows:

```lua
['taplo'] = function()
  require('lspconfig').taplo.setup({})
end,
```

If you use this approach, make sure you don't also manually set up servers
directly via `lspconfig` as this will cause servers to be set up more than
once.

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
- <https://github.com/ray-x/go.nvim>

## Languages

I am using `python` and `go` as my primary language so here I documented some useful
features of this configuration in those languages.

### Golang

`FillStruct` is one of my favorite features. In this configuration you can use `spc + c + a`
to see code actions and one of these actions on structures is filling them
[ref](https://github.com/ray-x/go.nvim/blob/master/lua/go/reftool.lua).
