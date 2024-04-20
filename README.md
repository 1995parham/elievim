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

```lua
return {
    -- modules/completion/plugins.lua
    {
      'neovim/nvim-lspconfig',
      -- used filetype to lazy load lsp
      -- config your language filetype in here
      ft = { 'lua','rust','c','cpp'},
      config = conf.nvim_lsp,
    },

    -- modules/tools/plugins.lua
    {
      'nvim-telescope/telescope.nvim',
      -- use command to lazy load.
      cmd = 'Telescope',
      config = conf.telescope,
      dependencies = {
        { 'nvim-lua/popup.nvim' },
        { 'nvim-lua/plenary.nvim' },
        { 'nvim-telescope/telescope-fzy-native.nvim' },
      }
    },
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

Use these APIs to config your key mapping in `keymap` folder. In this folder
`keymap/init.lua` is necessary but if you have many VIM modes' remap you can config them in `keymap/other-file.lua`
Then config plugins key mapping in `keymap/init.lua`. The example of API usage is as follows:

```lua
-- genreate keymap in normal mode
nmap {
  -- packer which is replaced by lazy.nvim
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
you want to have another key mapping not a command as RHS.

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

To utilize Language Servers, you'll typically need the following commands:

```bash
- luarocks
- npm / node
- pip / python
```

### Configuration

Language servers are configured in `lua/modules/completion/config.lua` based on
[`nvim-lspconfig`](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md).

- Install Language Servers: Use [`mason.nvim`](https://github.com/williamboman/mason.nvim) to install
  the language servers you need.
- Automatic Configuration (Recommended): Most language servers will be automatically configured
  by [`mason-lspconfig.nvim`](https://github.com/williamboman/mason-lspconfig.nvim).
- Manual Configuration (Optional): If a server isn't automatically configured, or you prefer manual setup,
  add configurations to `lua/modules/completion/config.lua`.

```lua
['taplo'] = function()
  require('lspconfig').taplo.setup({})
end,
```

If you use this approach, make sure you don't also manually set up servers
directly via `lspconfig` as this will cause servers to be set up more than
once.

## Tips

### Improve key repeat

```bash
# macOS (needs a restart)
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# Linux (X11)
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

This document outlines useful features of my development configuration
specifically designed for Python and Go projects.

### General

- Need to **comment out** a section of code while in virtual mode? This configuration offers a handy shortcut!
  Simply use the key combination `gc` while your selection is active.
  This will efficiently comment out all the lines within your chosen block.

### Golang

- I love the `FillStruct` feature included in this configuration!
  Here's how it works:

  1. Place your cursor inside a struct definition.
  2. Trigger the code actions menu using `spc + c + a` (or your preferred shortcut).
  3. Look for the Fill Struct action and select it.

  Voilà! Your struct will be populated with empty fields, ready for you to customize.
  The implementation details for this feature can be found in the `reftool.lua` file of the go.nvim plugin:
  <https://github.com/ray-x/go.nvim/blob/master/lua/go/reftool.lua>.
