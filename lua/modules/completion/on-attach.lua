local lsp = {}

if not lsp.augroup then
  lsp.augroup = vim.api.nvim_create_augroup('LspFormatting', {})
end

function lsp.formatting(bufnr)
  vim.notify('lsp_formatter is called', 'debug', { title = 'lsp' })

  vim.lsp.buf.format({
    filter = function(client)
      return client.name == 'null-ls'
    end,
    bufnr = bufnr,
  })
end

function lsp.on_attach(client, bufnr)
  vim.notify(string.format('lsp client %s registered by calling on_attach', client.name), 'debug', { title = 'lsp' })

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<Leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<Leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<Leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<Leader>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<Leader>f', vim.lsp.buf.format, bufopts)

  if client.supports_method('textDocument/formatting') then
    vim.notify(string.format('lsp client %s has formatting capability', client.name), 'debug', { title = 'lsp' })
    vim.api.nvim_clear_autocmds({ group = lsp.augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = lsp.augroup,
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

return lsp
