vim.opt.guifont = 'JetbrainsMono_NF:h8'
vim.g.neovide_scale_factor = 1.0
vim.g.neovide_transparency = 0.95
vim.opt.title = true
vim.opt.titlestring = '%{fnamemodify(getcwd(), ":~:s?~/Documents/Git? ?")}'

if vim.loop.os_uname().sysname == 'Darwin' then
  vim.g.neovide_scale_factor = 1.2
  vim.g.neovide_fullscreen = true
end
