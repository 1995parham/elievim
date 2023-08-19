-- author: glepnr https://github.com/glepnir
-- date: 2022-07-02
-- License: MIT
-- recommend plugins key defines in this file

require('keymap.config')
local key = require('core.keymap')
local nmap, tmap = key.nmap, key.tmap
local silent, noremap = key.silent, key.noremap
local opts = key.new_opts
local cmd = key.cmd

-- normal mode key mapping
nmap({
  -- packer
  { '<Leader>pu', cmd('PackerUpdate'), opts(noremap, silent) },
  { '<Leader>pi', cmd('PackerInstall'), opts(noremap, silent) },
  { '<Leader>pc', cmd('PackerCompile'), opts(noremap, silent) },
  -- dashboard
  { '<Leader>n', cmd('DashboardNewFile'), opts(noremap, silent) },
  { '<Leader>ss', cmd('SessionSave'), opts(noremap, silent) },
  { '<Leader>sl', cmd('SessionLoad'), opts(noremap, silent) },
  -- nvimtree
  { '<Leader>pff', cmd('NvimTreeToggle'), opts(noremap, silent) },
  -- Telescope
  { '<Leader>bb', cmd('Telescope buffers'), opts(noremap, silent, 'buffer browser') },
  { '<Leader>man', cmd('Telescope man_pages'), opts(noremap, silent) },
  { '<Leader>fa', cmd('Telescope live_grep'), opts(noremap, silent) },
  { '<Leader>ff', cmd('Telescope file_browser'), opts(noremap, silent, 'file browser') },
  { '<leader>sf', cmd('Telescope find_files'), opts(noremap, silent, '[s]earch [f]iles') },
  -- buffers
  { '<Leader>bn', cmd('bnext'), opts(noremap, silent, 'next buffer') },
  { '<Leader>bp', cmd('bprevious'), opts(noremap, silent, 'previous buffer') },
  {
    '<Leader>qq',
    cmd('.+,$bwipeout! <bar> .+,$bd! <bar> ToggleTermShutdownAll <bar> Dashboard'),
    opts(noremap, silent, 'back to dashboard'),
  },
  -- Panda
  {
    '<leader>dd',
    function()
      require('duck').hatch('🐼')
    end,
    opts('hatch the [d]uck'),
  },
  { '<Leader>dk', require('duck').cook, opts('coo[k] the [d]uck') },
  -- toggleterm
  { '<Leader>ot', cmd('ToggleTerm dir=git_dir direction=horizontal'), opts(silent, 'open/close horizental terminal') },
  {
    '<Leader>oo',
    cmd('exe v:count1 . "ToggleTerm dir=git_dir direction=tab"'),
    opts(silent, 'open/close terminal in a new tab'),
  },
  { '<Leader>odo', cmd('LazyDockerToogle'), opts(silent, 'open/close lazydocker') },
  { '<Leader>oi', cmd('IPythonToggle'), opts(silent, 'open/close ipython') },
  { '<Leader>odj', cmd('DjangoShellPlus'), opts(silent, 'open/close django shell_plus') },
  { '<Leader>hc', cmd('GitHistoryToggle'), opts(silent, 'show 5 last commit to help you write your commit message') },
})

-- terminal mode key mapping
tmap({
  '<ESC>',
  '<C-\\><C-n>',
  { silent = true },
})

for i = 1, 9, 1 do
  local keymap = {
    string.format('<M-%d>', i),
    cmd(string.format('%dToggleTerm dir=git_dir direction=tab', i)),
    opts(silent, string.format('open/close terminal %d in a new tab', i)),
  }

  tmap(keymap)
  nmap(keymap)
end

nmap({
  '<M-0>',
  cmd('ToggleTermToggleAll'),
  opts(silent, 'toggle all terminals at once'),
})

tmap({
  '<M-0>',
  cmd('ToggleTermToggleAll'),
  opts(silent, 'toggle all terminals at once'),
})
