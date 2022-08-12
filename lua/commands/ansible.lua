vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '**/playbook/*.yaml', '**/ansible/*.yaml', '**/playbook/*.yml', '**/ansible/*.yml' },
  command = 'set filetype=yaml.ansible',
})
