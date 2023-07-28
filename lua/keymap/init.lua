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

-- usage of plugins
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
  { '<Leader>bb', cmd('Telescope buffers'), opts(noremap, silent) },
  { '<Leader>man', cmd('Telescope man_pages'), opts(noremap, silent) },
  { '<Leader>fa', cmd('Telescope live_grep'), opts(noremap, silent) },
  { '<Leader>ff', cmd('Telescope file_browser'), opts(noremap, silent) },
  { '<leader>sf', cmd('Telescope find_files'), opts(noremap, silent, '[s]earch [f]iles') },
  -- Panda
  {
    '<leader>dd',
    function()
      require('duck').hatch('🐼')
    end,
    opts('hatch the [d]uck'),
  },
  { '<leader>dk', require('duck').cook, opts('coo[k] the [d]uck') },
  -- toggleterm
  { '<Leader>ot', cmd('ToggleTerm dir=git_dir direction=horizontal'), opts(silent, 'open horizental terminal') },
  { '<Leader>oo', cmd('ToggleTerm dir=git_dir direction=tab'), opts(silent, 'open terminal in a new tab') },
  { '<Leader>od', cmd('LazyDockerToogle'), opts(silent, 'open lazydocker') },
  { '<Leader>oi', cmd('IPythonToggle'), opts(silent, 'open ipython') },
  { '<Leader>od', cmd('DjangoShellPlus'), opts(silent, 'open django shell_plus') },
})

tmap({
  '<ESC>',
  '<C-\\><C-n>',
  { silent = true },
})
