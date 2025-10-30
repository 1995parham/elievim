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

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp_buf_conf', { clear = true }),
  callback = function(event_context)
    local client = vim.lsp.get_client_by_id(event_context.data.client_id)
    -- vim.print(client.name, client.server_capabilities)

    if not client then
      return
    end

    local bufnr = event_context.buf

    -- Show a fancy notification when LSP attaches
    vim.notify(string.format('Language server "%s" attached', client.name), vim.log.levels.INFO, {
      title = 'LSP',
      timeout = 2000,
    })
    -- key mapping for lsp and showing lsp before the mapping description.
    local nmap = function(keys, func, desc)
      if desc then
        desc = 'LSP: ' .. desc
      end

      local bufopts = { noremap = true, silent = true, buffer = bufnr, desc = desc }

      vim.keymap.set('n', keys, func, bufopts)
    end
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    -- Set keymaps only for buffers with an active LSP
    nmap('gD', vim.lsp.buf.declaration, '[g]oto [D]declaration')
    nmap('gd', vim.lsp.buf.definition, '[g]oto [d]efinition')
    nmap('gi', vim.lsp.buf.implementation, '[g]oto [i]mplementation')
    nmap('gr', require('fzf-lua').lsp_references, '[g]oto [r]eferences')
    nmap('K', vim.lsp.buf.hover, 'hover documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'signature documentation')
    nmap('<Leader>wa', vim.lsp.buf.add_workspace_folder, '[w]orkspace [a]dd Folder')
    nmap('<Leader>wr', vim.lsp.buf.remove_workspace_folder, '[w]orkspace [r]emove Folder')
    nmap('<Leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[w]orkspace [l]ist Folders')
    nmap('<Leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
    nmap('<Leader>rn', vim.lsp.buf.rename, '[r]e[n]ame')
    nmap('<Leader>ca', vim.lsp.buf.code_action, '[c]ode [a]ction')
    nmap('<leader>ds', require('fzf-lua').lsp_document_symbols, '[d]ocument [s]ymbols')
    nmap('<leader>ws', require('fzf-lua').lsp_live_workspace_symbols, '[w]orkspace [s]ymbols')
    nmap('<leader>uh', function()
      vim.lsp.inlay_hint(vim.api.nvim_get_current_buf(), nil)
    end, 'toggle inlay hint')

    nmap('<Leader>lr', function()
      -- Restart the specific LSP client for this buffer
      vim.lsp.stop_client(vim.lsp.get_clients({ bufnr = bufnr }))
      vim.defer_fn(function()
        vim.cmd('edit')
      end, 100)
    end, '[l]sp [r]estart for current buffer')

    nmap('<Leader>lR', function()
      local clients = vim.lsp.get_clients()
      for _, client in pairs(clients) do
        vim.lsp.stop_client(client.id)
      end
      vim.defer_fn(function()
        vim.cmd('bufdo edit')
      end, 100)
      vim.notify('All LSP clients restarted', vim.log.levels.INFO, { title = 'LSP' })
    end, '[l]sp [R]estart all clients')

    nmap('<Leader>lf', function()
      for _, c in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
        if c.server_capabilities.workspace then
          if c.server_capabilities.workspace.workspaceFolders then
            vim.notify(
              string.format('Refreshing workspace for %s', c.name),
              vim.log.levels.INFO,
              { title = 'LSP' }
            )
          end
        end
        vim.diagnostic.reset(nil, c.id)
        vim.lsp.buf_request(bufnr, 'textDocument/diagnostic', {
          textDocument = vim.lsp.util.make_text_document_params(bufnr),
        })
      end
    end, '[l]sp re[f]resh workspace')

    nmap('<Leader>li', function()
      local clients = vim.lsp.get_clients({ bufnr = bufnr })
      if #clients == 0 then
        vim.notify('No LSP clients attached', vim.log.levels.WARN, { title = 'LSP' })
        return
      end

      local lines = {}
      for _, c in pairs(clients) do
        table.insert(lines, string.format('Client: %s (id: %d)', c.name, c.id))
        table.insert(lines, string.format('  Root: %s', c.config.root_dir or 'none'))
        if c.workspace_folders then
          table.insert(lines, '  Workspace folders:')
          for _, folder in ipairs(c.workspace_folders) do
            table.insert(lines, string.format('    - %s', folder.name))
          end
        end
        table.insert(lines, '')
      end

      vim.notify(table.concat(lines, '\n'), vim.log.levels.INFO, { title = 'LSP Info', timeout = 5000 })
    end, '[l]sp [i]nfo')

    if pcall(require, 'navigator') then
      -- setup navigator for lsp client
      require('navigator.lspclient.mapping').setup({ bufnr = bufnr, client = client })
      -- enable identifier highlight on hover
      require('navigator.dochighlight').documentHighlight(bufnr)
      -- configure doc highlight
      require('navigator.lspclient.highlight').add_highlight()
    end
  end,
})

return lsp
