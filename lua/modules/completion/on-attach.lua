local lsp = {}

if not lsp.augroup then
  lsp.augroup = {}
  lsp.augroup[1] = vim.api.nvim_create_augroup('LspFormatting', {})
  lsp.augroup[2] = vim.api.nvim_create_augroup('LspDiagnostic', {})
end

lsp.diagnostic_icons = {
  [vim.diagnostic.severity.ERROR] = '',
  [vim.diagnostic.severity.HINT] = '',
  [vim.diagnostic.severity.INFO] = '',
  [vim.diagnostic.severity.WARN] = '',
}

lsp.valid_formatters = {
  ['null-ls'] = true,
  ['dockerls'] = true,
  ['docker_compose_language_service'] = true,
  ['jdtls'] = true,
}

--- HACK: Override `vim.lsp.util.stylize_markdown` to use Treesitter.
---@param bufnr integer
---@param contents string[]
---@param opts table
---@return string[]
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.util.stylize_markdown = function(bufnr, contents, opts)
  contents = vim.lsp.util._normalize_markdown(contents, {
    width = vim.lsp.util._make_floating_popup_size(contents, opts),
  })
  vim.bo[bufnr].filetype = 'markdown'
  vim.treesitter.start(bufnr)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, contents)

  return contents
end

function lsp.formatting(bufnr)
  -- vim.notify('lsp_formatter is called', vim.log.levels.DEBUG)

  vim.lsp.buf.format({
    filter = function(client)
      return lsp.valid_formatters[client.name] == true
    end,
    bufnr = bufnr,
  })
end

function lsp.on_attach(client, bufnr)
  -- vim.notify(string.format('lsp client %s registered by calling on_attach', client.name), vim.log.levels.DEBUG)

  -- https://neovim.io/doc/user/lsp.html#lsp-handlers
  if vim.fn.has('nvim-0.10') == 1 then
    local float = require('modules.completion.float')

    vim.lsp.handlers['textDocument/hover'] = float.enhanced_float_handler(vim.lsp.handlers.hover)
    vim.lsp.handlers['textDocument/signatureHelp'] = float.enhanced_float_handler(vim.lsp.handlers.signature_help)
  end

  -- key mapping for lsp and showing lsp before the mapping description.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    local bufopts = { noremap = true, silent = true, buffer = bufnr, desc = desc }

    vim.keymap.set('n', keys, func, bufopts)
  end
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  nmap('gD', vim.lsp.buf.declaration, '[g]oto [D]declaration')
  nmap('gd', vim.lsp.buf.definition, '[g]oto [d]efinition')
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
  nmap('gi', vim.lsp.buf.implementation, '[g]oto [i]mplementation')
  nmap('<Leader>wa', vim.lsp.buf.add_workspace_folder, '[w]orkspace [a]dd Folder')
  nmap('<Leader>wr', vim.lsp.buf.remove_workspace_folder, '[w]orkspace [r]emove Folder')
  nmap('<Leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[w]orkspace [l]ist Folders')
  nmap('<Leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<Leader>rn', vim.lsp.buf.rename, '[r]e[n]ame')
  nmap('<Leader>ca', vim.lsp.buf.code_action, '[c]ode [a]ction')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
  nmap('<leader>uh', function()
    vim.lsp.inlay_hint(vim.api.nvim_get_current_buf(), nil)
  end, 'Toggle Inlay Hint')

  if client.supports_method('textDocument/formatting') then
    -- vim.notify(string.format('lsp client %s has formatting capability', client.name), vim.log.levels.DEBUG)
    vim.api.nvim_clear_autocmds({ group = lsp.augroup[1], buffer = bufnr })
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = lsp.augroup[1],
      buffer = bufnr,
      callback = function()
        lsp.formatting(bufnr)
      end,
    })
  end
end

-- these are custom configuration for each lsp, please create lsp configuration
-- here instead of creating them in config.lua.
-- following link, contains information about supported lsp:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

function lsp.lua_ls()
  -- local sumneko_binary_path = vim.fn.exepath('lua-language-server')
  -- local sumneko_root_path = vim.fn.fnamemodify(sumneko_binary_path, ':h:h:h')

  local runtime_path = vim.split(package.path, ';')
  table.insert(runtime_path, 'lua/?.lua')
  table.insert(runtime_path, 'lua/?/init.lua')

  return {
    -- cmd = { sumneko_binary_path, '-E', sumneko_root_path .. '/main.lua' },
    on_attach = lsp.on_attach,
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

function lsp.ltex_ls()
  return {
    on_attach = function(client, bufnr)
      require('ltex_extra').setup({
        path = os.getenv('HOME') .. '/.config/nvim/spell/',
      })
      lsp.on_attach(client, bufnr)
    end,
    filetypes = { 'gitcommit', 'markdown', 'org', 'plaintex', 'rst', 'rnoweb' },
    settings = {},
  }
end

function lsp.gols()
  local util = require('lspconfig/util')

  return {
    on_attach = lsp.on_attach,
    cmd = { 'gopls', 'serve' },
    filetypes = { 'go', 'gomod' },
    root_dir = util.root_pattern('go.work', 'go.mod', '.git'),
    flags = { allow_incremental_sync = true, debounce_text_changes = 500 },
    completeUnimported = true,
    -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
    settings = {
      gopls = {
        -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
        -- analyses = {},
        allExperiments = true,
        hints = {
          parameterNames = true,
          rangeVariableTypes = true,
        },
        usePlaceholders = true,
        codelenses = {
          generate = true,
          test = true,
        },
        staticcheck = true,
      },
    },
  }
end

function lsp.docker_compose_language_service()
  local util = require('lspconfig/util')

  return {
    on_attach = lsp.on_attach,
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

function lsp.helm_ls()
  local util = require('lspconfig/util')

  return {
    filetypes = { 'helm' },
    cmd = { 'helm_ls', 'serve' },
    root_dir = function(fname)
      return util.root_pattern('Chart.yaml')(fname)
    end,
  }
end

return lsp
