local servers = {}

-- these are custom configuration for each lsp, please create lsp configuration
-- here instead of creating them in config.lua.
-- :h vim.lsp.Config
-- :h vim.lsp.ClientConfig
-- following link, contains information about supported lsp:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

---@return vim.lsp.Client
function servers.lua_ls()
  -- local sumneko_binary_path = vim.fn.exepath('lua-language-server')
  -- local sumneko_root_path = vim.fn.fnamemodify(sumneko_binary_path, ':h:h:h')

  local runtime_path = vim.split(package.path, ';')
  table.insert(runtime_path, 'lua/?.lua')
  table.insert(runtime_path, 'lua/?/init.lua')

  return {
    -- cmd = { sumneko_binary_path, '-E', sumneko_root_path .. '/main.lua' },
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
          -- Setup your lua path
          path = runtime_path,
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { 'vim' },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file('', true),
        },
        hint = {
          enable = true,
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  }
end

---@return vim.lsp.Client
function servers.ltex()
  return {
    on_attach = function(_, _)
      require('ltex_extra').setup({
        path = os.getenv('HOME') .. '/.config/nvim/spell/',
      })
    end,
    filetypes = { 'gitcommit', 'markdown', 'org', 'plaintext', 'rst', 'rnoweb' },
    settings = {},
  }
end

---@return vim.lsp.Client
function servers.gopls()
  return {
    flags = { allow_incremental_sync = true, debounce_text_changes = 500 },
    completeUnimported = true,
    -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
    settings = {
      gopls = {
        -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
        -- analyses = {},
        hints = {
          parameterNames = true,
          rangeVariableTypes = true,
        },
        gofumpt = true,
        usePlaceholders = true,
        staticcheck = true,
        hoverKind = 'FullDocumentation',
        codelenses = {
          generate = true,
          test = true,
          upgrade_dependency = true,
          tidy = true,
          regenerate_cgo = true,
          vendor = false,
        },
      },
    },
  }
end

---@return vim.lsp.Client
function servers.ruff()
  return {
    on_attach = function(client, _)
      if client.name == 'ruff' then
        -- Disable hover in favor of Pyright
        client.server_capabilities.hoverProvider = false
      end
    end,
  }
end

---@return vim.lsp.Client
function servers.phpactor()
  return {
    init_options = {
      ['language_server_phpstan.enabled'] = false,
      ['language_server_psalm.enabled'] = false,
      ['core.min_memory_limit'] = -1,
    },
  }
end

---@return vim.lsp.Client
function servers.docker_compose_language_service()
  local util = require('lspconfig/util')

  return {
    root_dir = function(fname)
      local helm_root = util.root_pattern('Chart.yaml')
      -- docker-compose-language-service runs on every yaml file and trying to format and lint
      -- them. I cannot find a way for preventing it to run so I force it to run on workspace mode
      -- by disabling the single_file_support and then send nil when we are in the helm directory.
      if helm_root ~= nil then
        return nil
      end

      return util.root_pattern('docker-compose.yml', 'docker-compose.yaml', '.git')(fname)
    end,
    single_file_support = false,
  }
end

---@return vim.lsp.Client
function servers.helm_ls()
  local util = require('lspconfig/util')

  return {
    filetypes = { 'helm' },
    cmd = { 'helm_ls', 'serve' },
    root_dir = function(fname)
      return util.root_pattern('Chart.yaml')(fname)
    end,
  }
end

return servers
