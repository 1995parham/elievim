-- author: glepnr https://github.com/glepnir
-- date: 2022-07-02
-- License: MIT

local config = {}

-- config server in this function
function config.nvim_lsp() end

config.mason = {}

function config.mason.setup()
  require("mason").setup({
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗"
      }
    }
  })
end

function config.mason.installer()
  require('mason-tool-installer').setup({
    -- a list of all tools you want to ensure are installed upon
    -- start; they should be the names Mason uses for each tool
    ensure_installed = {
      'golangci-lint',
      'gopls',
      'bash-language-server',
      'lua-language-server',
      'vim-language-server',
      'stylua',
      'shellcheck',
      'editorconfig-checker',
      'gofumpt',
      'golines',
      'gomodifytags',
      'gotests',
      'impl',
      'json-to-struct',
      'luacheck',
      'misspell',
      'revive',
      'shellcheck',
      'shfmt',
      'staticcheck',
      'vint',
      'sql-formatter',
      'jq',
    },

    -- if set to true this will check each tool for updates. If updates
    -- are available the tool will be updated. This setting does not
    -- affect :MasonToolsUpdate or :MasonToolsInstall.
    -- Default: false
    auto_update = false,

    -- automatically install / update on startup. If set to false nothing
    -- will happen on startup. You can use :MasonToolsInstall or
    -- :MasonToolsUpdate to install tools and check for updates.
    -- Default: true
    run_on_start = true,

    -- set a delay (in ms) before the installation starts. This is only
    -- effective if run_on_start is set to true.
    -- e.g.: 5000 = 5 second delay, 10000 = 10 second delay, etc...
    -- Default: 0
    start_delay = 3000,  -- 3 second delay
  })
end

function config.mason.lspconfig()
  require("mason-lspconfig").setup({
    ensure_installed = {
      "golangci_lint_ls",
      "gopls",
    },
    automatic_installation = false,
  })
end

function config.null_ls()
  local null_ls = require("null-ls")
  null_ls.setup({
    sources = {
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.sql_formatter,
      null_ls.builtins.formatting.jq,
    },
  })
end

function config.lspsaga()
  local saga = require("lspsaga")

  saga.init_lsp_saga({
  })
end

function config.lua_snip()
  local ls = require('luasnip')
  local types = require('luasnip.util.types')
  ls.config.set_config({
    history = true,
    enable_autosnippets = true,
    updateevents = 'TextChanged,TextChangedI',
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { '<- choiceNode', 'Comment' } },
        },
      },
    },
  })
  require('luasnip.loaders.from_lua').lazy_load({
    paths = vim.fn.stdpath('config') .. '/snippets'
  })
  require('luasnip.loaders.from_vscode').lazy_load()
  require('luasnip.loaders.from_vscode').lazy_load({
    paths = { './snippets/' },
  })
end

return config
