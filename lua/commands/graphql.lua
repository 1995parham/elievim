vim.api.nvim_create_autocmd('FileType', {
  pattern = 'graphql',
  callback = function()
    vim.bo.commentstring = '# %s'
  end,
})
