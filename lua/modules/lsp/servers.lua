local servers = {}

-- these are custom configuration for each lsp, please create lsp configuration
-- here instead of creating them in config.lua.
-- :h vim.lsp.Config
-- :h vim.lsp.ClientConfig
-- following link, contains information about supported lsp:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

---@return vim.lsp.Client
function servers.ltex()
  ---@diagnostic disable-next-line: return-type-mismatch
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

function servers.basedpyright()
  return {
    settings = {
      basedpyright = {
        analysis = {
          typeCheckingMode = 'standard',
          autoSearchPaths = true,
          diagnosticMode = 'openFilesOnly',
          useLibraryCodeForTypes = true,
        },
      },
    },
  }
end

---@return vim.lsp.Client
function servers.gopls()
  ---@diagnostic disable-next-line: return-type-mismatch
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
  ---@diagnostic disable-next-line: return-type-mismatch
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
  ---@diagnostic disable-next-line: return-type-mismatch
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
    ---@return string?
    ---@diagnostic disable-next-line: assign-type-mismatch
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
    ---@return string?
    ---@diagnostic disable-next-line: assign-type-mismatch
    root_dir = function(fname)
      return util.root_pattern('Chart.yaml')(fname)
    end,
  }
end

return servers
