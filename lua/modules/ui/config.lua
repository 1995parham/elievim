-- author: glepnr https://github.com/glepnir
--
-- date: 2022-07-02
-- License: MIT

local config = {}

function config.naz()
  require('naz')
end

function config.galaxyline()
  require('modules.ui.eviline')
end

function config.dashboard()
  local version = vim.version()
  local relationship_start_time = os.time({
    year = 2020,
    month = 2,
    day = 13,
    hour = 22,
    min = 26,
    sec = 0,
  })

  local cwd = vim.fn.getcwd()
  local username = (os.getenv('USER') or '')
  local status, lsputil = pcall(require, 'lspconfig/util')
  if status then
    local root = lsputil.root_pattern('.git')(cwd)
    if root ~= nil then
      username = string.format(
        '%s <%s>',
        vim.api.nvim_exec2('Git config user.name', { output = true }).output,
        vim.api.nvim_exec2('Git config user.email', { output = true }).output
      )
      cwd = root
    end
  end

  cwd = cwd:gsub(os.getenv('HOME') or '', ' ')

  local tehran_date = ''
  if vim['system'] ~= nil then
    tehran_date = vim
        .system({ 'date' }, {
          env = { TZ = 'Asia/Tehran' },
        })
        :wait().stdout
        :gsub('[\n]', '')
  end

  local header = {
    '',
    '████████████████▀▀████████████',
    '████████████▀▀▀╵╵╶╶▗▔▔▀███████',
    '██████████▀╴╵╵▁▃▄▆▇█▆▖╵▐██████',
    '█████████▘╶╴▅▍╾▔▔██▀▀█▖▐██████',
    '████┹▔▀▛▔╵╴▐██▆▆▇█▙▂▟▊▕███████',
    '██▘╵╷╵╷╴╵╴╴▐███▛▜███▛▘▗███████',
    '╵╵╵┈╵╷╵╷╶╴╴╴▔▀█▅▇▇▀▘╷╶████████',
    '╵╵╵╵╶╶╵╵╷╴╴╴╴╴╵╵▔╷╶╷╶╵╶▔▝█████',
    '╷╷╵╵╵╴╴╴╵╴╷╷╷╷╷╶╴╴╵╴╷╵╶╵▜█████',
    '╵╵╴╵╵╴╴╴╶╵╵╵╵╵╵╶╵╴╵╵╷╷╵╶▕█████',
    '╵╵╴╴╴╴╴╴╴╶╵╷╷╷╶╵╴╴╶╶╶╷╷╵▕█████',
    '',
    string.format('neovim %d.%d.%d', version.major, version.minor, version.patch),
    vim.fn.strftime('%c') .. ' on ' .. vim.fn.hostname(),
    '',
    '',
  }
  if username:lower():find('parham') then
    header = vim.list_extend({
      '▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄',
      '█▀░██▀▄▄▀█▀▄▄▀█░▄▄█▀▄▄▀█░▄▄▀█░▄▄▀█░████░▄▄▀█░▄▀▄░',
      '██░██▄▀▀░█▄▀▀░█▄▄▀█░▀▀░█░▀▀░█░▀▀▄█░▄▄░█░▀▀░█░█▄█░',
      '█▀░▀██▀▀▄██▀▀▄█▀▀▄█░████▄██▄█▄█▄▄█▄██▄█▄██▄█▄███▄',
      '▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀',
    }, header)
  elseif username ~= '' then
    header = vim.list_extend({
      '',
      '',
      string.format('Welcome %s to neovim!', username:match('(%a+)')),
      '',
      '',
    }, header)
  end

  local db = require('dashboard')
  db.setup({
    theme = 'doom',
    hide = {
      statusline = false,
    },
    disable_move = true,
    config = {
      header = header,
      center = {
        {
          icon = '',
          icon_hl = 'DashboardCenterIcon',
          desc = string.format('  %s', cwd),
          desc_hl = 'DashboardCenter',
        },
        {
          icon = '󰥔',
          icon_hl = 'DashboardCenterIcon',
          desc = string.format('  %s', tehran_date),
          desc_hl = 'DashboardCenter',
        },
        {
          icon = '',
          icon_hl = 'DashboardCenterIcon',
          desc = string.format('  %s', username),
          desc_hl = 'DashboardCenter',
        },
        {
          icon = '',
          icon_hl = 'DashboardCenterIcon',
          desc = '',
          desc_hl = 'DashboardCenter',
        },
        {
          icon = '',
          icon_hl = 'DashboardCenterIcon',
          desc = '',
          desc_hl = 'DashboardCenter',
        },
      },
      footer = {
        '',
        string.format('💘 %s', os.date('%H:%M %A %d %B %Y', relationship_start_time)),
        string.format('💞 %d days ago', os.difftime(os.time(), relationship_start_time) / (3600 * 24)),
        '',
      },
    },
  })
end

function config.nvim_bufferline()
  require('bufferline').setup({
    options = {
      modified_icon = '✥',
      buffer_close_icon = '',
      always_show_bufferline = false,
    },
  })
end

function config.nvim_tree()
  require('nvim-tree').setup({
    disable_netrw = false,
    hijack_cursor = true,
    hijack_netrw = true,
  })
end

function config.tterm()
  vim.env.GIT_EDITOR = 'nvr -cc split --remote-wait'

  vim.api.nvim_create_autocmd({ 'FileType' }, {
    pattern = { 'gitcommit', 'gitrebase', 'gitconfig' },
    command = 'set bufhidden=delete',
  })

  require('toggleterm').setup({
    insert_mappings = true,
    highlights = {
      Normal = {
        guibg = '#1f1f1f',
      },
    },
  })

  local Terminal = require('toggleterm.terminal').Terminal
  local terms = require('toggleterm.terminal')

  local lazydocker = Terminal:new({
    hidden = true,
    direction = 'float',
    close_on_exit = true,
    cmd = 'lazydocker',
  })

  local ipython = Terminal:new({
    hidden = true,
    direction = 'vertical',
    dir = 'git_dir',
    close_on_exit = true,
    cmd = 'ipython',
  })

  local django_shell_plus = Terminal:new({
    hidden = true,
    dir = 'git_dir',
    direction = 'vertical',
    close_on_exit = true,
    cmd = 'python manage.py shell_plus',
  })

  local commit_history = Terminal:new({
    hidden = true,
    direction = 'float',
    dir = 'git_dir',
    close_on_exit = true,
    cmd = 'git log --pretty=oneline -10 --no-merges',
    float_opts = {
      border = 'double',
      width = 200,
      height = 20,
    },
  })

  vim.api.nvim_create_user_command('LazyDockerToogle', function()
    lazydocker:toggle()
  end, {})

  vim.api.nvim_create_user_command('IPythonToggle', function()
    ipython:toggle()
  end, {})

  vim.api.nvim_create_user_command('DjangoShellPlusToggle', function()
    django_shell_plus:toggle()
  end, {})

  vim.api.nvim_create_user_command('GitHistoryToggle', function()
    commit_history:toggle()
  end, {})

  vim.api.nvim_create_user_command('ToggleTermShutdownAll', function()
    local terminals = terms.get_all()

    for _, term in pairs(terminals) do
      term:shutdown()
    end
  end, { bang = false, bar = true })
end

return config
