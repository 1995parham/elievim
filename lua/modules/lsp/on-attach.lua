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
    vim.notify(
      string.format('Language server "%s" attached', client.name),
      vim.log.levels.INFO,
      {
        title = 'LSP',
        timeout = 2000,
      }
    )
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

-- Show notification when LSP detaches
vim.api.nvim_create_autocmd('LspDetach', {
  group = vim.api.nvim_create_augroup('lsp_detach_notif', { clear = true }),
  callback = function(event_context)
    local client = vim.lsp.get_client_by_id(event_context.data.client_id)
    if client then
      vim.notify(
        string.format('Language server "%s" detached', client.name),
        vim.log.levels.WARN,
        {
          title = 'LSP',
          timeout = 2000,
        }
      )
    end
  end,
})

return lsp
