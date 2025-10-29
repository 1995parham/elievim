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

vim.keymap.del('i', '<Tab>')

-- normal mode key mapping
nmap({
  -- dashboard
  { '<Leader>n', cmd('DashboardNewFile'), opts(noremap, silent) },
  { '<Leader>ss', cmd('SessionSave'), opts(noremap, silent) },
  { '<Leader>sl', cmd('SessionLoad'), opts(noremap, silent) },
  -- nvimtree
  { '<Leader>pff', cmd('NvimTreeToggle'), opts(noremap, silent) },
  -- FzfLua
  { '<Leader>bb', cmd('FzfLua buffers'), opts(noremap, silent, 'buffer browser') },
  { '<Leader>man', cmd('FzfLua manpages'), opts(noremap, silent) },
  { '<Leader>fa', cmd('FzfLua live_grep'), opts(noremap, silent) },
  { '<leader>sf', cmd('FzfLua files'), opts(noremap, silent, '[s]earch [f]iles') },
  -- buffers
  { '<Leader>bn', cmd('bnext'), opts(noremap, silent, 'next buffer') },
  { '<Leader>bp', cmd('bprevious'), opts(noremap, silent, 'previous buffer') },
  {
    '<Leader>qq',
    cmd('%bwipeout! <bar> %bd! <bar> Dashboard'),
    opts(noremap, silent, 'back to dashboard'),
  },
  -- do want to have a Panda in your neovim?
  {
    '<leader>dd',
    function()
      require('duck').hatch('🐼')
    end,
    opts('hatch the [d]uck'),
  },
  { '<Leader>dk', require('duck').cook, opts('coo[k] the [d]uck') },
  -- toggleterm with its friends
  {
    '<Leader>ot',
    cmd('ToggleTerm dir=git_dir direction=horizontal size=35'),
    opts(silent, 'open/close horizental terminal'),
  },
  {
    '<Leader>oo',
    cmd('exe v:count1 . "ToggleTerm dir=git_dir direction=tab"'),
    opts(silent, 'open/close terminal in a new tab'),
  },
  { '<Leader>odo', cmd('LazyDockerToogle'), opts(silent, 'open/close lazydocker') },
  { '<Leader>oi', cmd('IPythonToggle'), opts(silent, 'open/close ipython') },
  { '<Leader>odj', cmd('DjangoShellPlusToggle'), opts(silent, 'open/close django shell_plus') },
  { '<Leader>hc', cmd('GitHistoryToggle'), opts(silent, 'show 5 last commit to help you write your commit message') },
  -- Notifications
  {
    '<Leader>nd',
    function()
      require('notify').dismiss({ silent = true, pending = true })
    end,
    opts('dismiss all notifications'),
  },
  {
    '<Leader>nh',
    function()
      require('notify').history()
    end,
    opts('show notification history'),
  },
  -- LSP info
  {
    '<Leader>li',
    function()
      local clients = vim.lsp.get_active_clients()
      if #clients == 0 then
        vim.notify('No LSP clients attached', vim.log.levels.INFO, { title = 'LSP' })
      else
        local client_names = {}
        for _, client in ipairs(clients) do
          table.insert(client_names, '  • ' .. client.name)
        end
        vim.notify(
          string.format('%d LSP client(s) attached:\n%s', #clients, table.concat(client_names, '\n')),
          vim.log.levels.INFO,
          { title = 'LSP Info', timeout = 5000 }
        )
      end
    end,
    opts('[l]sp [i]nfo - show active LSP clients'),
  },
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
