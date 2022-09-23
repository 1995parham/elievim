local id = vim.api.nvim_create_augroup('ansible_vim_playbook', {})

vim.api.nvim_create_autocmd({ 'BufWinEnter', 'BufNewFile' }, {
  group = id,
  pattern = {
    '*/*playbook*/*.yml',
    '*/*playbook*/*.yaml',
    '*/*ansible*/*.yml',
    '*/*ansible*/*.yaml',
  },
  command = 'set ft=yaml.ansible',
  desc = 'use yaml.ansible filetype for ansiblels to work',
})
