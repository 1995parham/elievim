-- author: glepnr https://github.com/glepnir
-- date: 2022-07-02
-- License: MIT
local cache_dir = os.getenv('HOME') .. '/.cache/nvim/'

vim.opt.termguicolors = true
-- enable mouse support in normal and visual mode.
vim.opt.mouse = 'nv'
vim.opt.errorbells = true
vim.opt.visualbell = true
vim.opt.hidden = true
vim.opt.fileformats = 'unix,mac,dos'
vim.opt.magic = true
vim.opt.virtualedit = 'block'
vim.opt.encoding = 'utf-8'
vim.opt.viewoptions = 'folds,cursor,curdir,slash,unix'
vim.opt.sessionoptions = 'curdir,help,tabpages,winsize'
vim.opt.clipboard = 'unnamedplus'
vim.opt.wildignorecase = true
vim.opt.wildignore = (
  '.git,.hg,.svn,*.pyc,*.o,*.out,*.jpg,*.jpeg,*.png,*.gif,*.zip'
  .. ',**/tmp/**,*.DS_Store,**/node_modules/**,**/bower_modules/**'
)
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.directory = cache_dir .. 'swag/'
vim.opt.undodir = cache_dir .. 'undo/'
vim.opt.backupdir = cache_dir .. 'backup/'
vim.opt.viewdir = cache_dir .. 'view/'
vim.opt.spellfile = cache_dir .. 'spell/en.uft-8.add'
vim.opt.history = 2000
-- if you exit Vim and later start it again, you would normally lose a lot of
-- information.  the ShaDa file can be used to remember that information, which
-- enables you to continue where you left off.
vim.opt.shada = "!,'300,<50,@100,s10,h"
vim.opt.backupskip = '/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim'
vim.opt.smarttab = true
vim.opt.shiftround = true
vim.opt.timeout = true
vim.opt.ttimeout = true
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 10
vim.opt.updatetime = 250
vim.opt.redrawtime = 1500
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.infercase = true
vim.opt.incsearch = true
vim.opt.wrapscan = true
vim.opt.complete = '.,w,b,k'
-- When nonempty, shows the effects of |:substitute|, |:smagic|,
-- :snomagic| and user commands with the |:command-preview| flag as you
-- type.
vim.opt.inccommand = 'nosplit'
vim.opt.grepformat = '%f:%l:%c:%m'
vim.opt.grepprg = 'rg --hidden --vimgrep --smart-case --'
vim.opt.breakat = [[\ \	;:,!?]]
vim.opt.startofline = false
vim.opt.whichwrap = 'h,l,<,>,[,],~'
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.switchbuf = 'useopen'
vim.opt.backspace = 'indent,eol,start'
vim.opt.diffopt = 'filler,iwhite,internal,algorithm:patience'
vim.opt.completeopt = 'menu,menuone,noselect'
vim.opt.jumpoptions = 'stack'
vim.opt.showmode = false
vim.opt.shortmess = 'aoOTIcF'
vim.opt.scrolloff = 2
vim.opt.sidescrolloff = 5
vim.opt.foldlevelstart = 99
vim.opt.ruler = false
vim.opt.list = true
vim.opt.listchars = 'tab:  ,nbsp:+,trail:·,extends:→,precedes:←'
vim.opt.showtabline = 2
vim.opt.winwidth = 30
vim.opt.winminwidth = 10
vim.opt.pumheight = 15
vim.opt.helpheight = 12
vim.opt.previewheight = 12
vim.opt.showcmd = false
vim.opt.cmdheight = 2
vim.opt.cmdwinheight = 5
vim.opt.equalalways = false
vim.opt.laststatus = 2
vim.opt.display = 'lastline'
vim.opt.showbreak = '↳  '
vim.opt.pumblend = 10
vim.opt.winblend = 10

vim.opt.undofile = true
vim.opt.synmaxcol = 2500
vim.opt.formatoptions = '1jcroql'
vim.opt.textwidth = 120
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = -1
vim.opt.breakindentopt = 'shift:2,min:20'
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.number = true
vim.opt.colorcolumn = '120'
vim.opt.signcolumn = 'yes'
-- vim.opt.conceallevel = 2
-- vim.opt.concealcursor = 'niv'
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldenable = false
vim.opt.foldtext = 'v:lua.vim.treesitter.foldtext()'

if vim.fn.executable('fish') == 1 then
  vim.opt.shell = 'fish'
else
  vim.opt.shell = 'bash'
end

if vim.loop.os_uname().sysname == 'Darwin' then
  vim.g.clipboard = {
    name = 'macOS-clipboard',
    copy = {
      ['+'] = 'pbcopy',
      ['*'] = 'pbcopy',
    },
    paste = {
      ['+'] = 'pbpaste',
      ['*'] = 'pbpaste',
    },
    cache_enabled = 0,
  }
  vim.g.python_host_prog = '/usr/bin/python'
  vim.g.python3_host_prog = '/usr/local/bin/python3'
end
