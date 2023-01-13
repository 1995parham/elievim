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
  ['jdtls'] = true,
}

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

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- the following code shows the diagnostic messages when hovering them
  -- but it has many performan issues so I eventually fallback to the old ways.
  --[[
  vim.api.nvim_clear_autocmds({ group = lsp.augroup[2], buffer = bufnr })
  vim.api.nvim_create_autocmd({ 'CursorHold' }, {
    buffer = bufnr,
    group = lsp.augroup[2],
    callback = function()
      local opts = {
        focusable = false,
        close_events = { 'BufLeave', 'InsertEnter', 'FocusLost', 'CursorMoved' },
        border = 'rounded',
        source = 'always',
        prefix = function(diagnostic, i, total)
          return string.format('%s %d/%d ', lsp.diagnostic_icons[diagnostic.severity], i, total)
        end,
        scope = 'line',
      }
      vim.diagnostic.open_float(nil, opts)
    end,
  })
  ]]

  -- Mappings.
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
  nmap('gr', require('telescope.builtin').lsp_references, 'References')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

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

function lsp.sumneko_lua()
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
    on_attach = lsp.on_attach,
    filetypes = { 'gitcommit', 'markdown', 'org', 'plaintex', 'rst', 'rnoweb' },
    settings = {
      ltex = {
        dictionary = {
          ['en-US'] = {
            'Parham',
            'Alvani',
            'Elahe',
            'Raha',
            'Dastan',
            'ADATA',
            'neovim',
            'nvim',
            'Ackerman',
            'EMQx',
            'EMQ',
            'Soteria',
            'Confisus',
            'MiA',
            'AUT',
            'I1820',
            'Herald',
            'Rasti',
            'Bakhshi',
            'LoRa',
            'LoRaWAN',
          },
        },
      },
    },
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
    settings = {
      gopls = {
        -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
        -- analyses = {},
        hints = {
          parameterNames = true,
          rangeVariableTypes = true,
        },
        staticcheck = true,
      },
    },
  }
end

return lsp
