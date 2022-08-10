local go = {}

function go.parse_stdout_data(data)
  if not data then
    return nil
  end
  -- Because the nvim.stdout's data will have an extra empty line at end on some OS (e.g. maxOS), we should remove it.
  for _ = 1, 3, 1 do
    if data[#data] == '' then
      table.remove(data, #data)
    end
  end
  if #data < 1 then
    return nil
  end
  return data
end

function go.doc(func)
  if func == nil then
    return vim.lsp.buf.hover()
  end

  local setup = { 'go', 'doc', func }

  vim.fn.jobstart(setup, {
    on_stdout = function(_, data, _)
      data = go.parse_stdout_data(data)
      if not data then
        return
      end

      local close_events = { 'CursorMoved', 'CursorMovedI', 'BufHidden', 'InsertCharPre' }
      local config = { close_events = close_events, focusable = true, border = 'single' }
      vim.lsp.util.open_floating_preview(data, 'go', config)
    end,
  })
end

vim.api.nvim_create_user_command('GoDoc', function(opts)
  go.doc(unpack(opts.fargs))
end, { desc = 'go.doc', nargs = '*' })
