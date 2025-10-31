local config = {}

function config.naz()
  vim.cmd('colorscheme naz')
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
      local ok_name, name = pcall(vim.api.nvim_exec2, 'Git config user.name', { output = true })
      local ok_email, email = pcall(vim.api.nvim_exec2, 'Git config user.email', { output = true })
      if ok_name and ok_email then
        username = string.format('%s <%s>', name.output, email.output)
        cwd = root
      end
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
    '',
    'XXXXXXXXXxXxxxxxxxxXXXXXXXXXXXXXXXXX',
    'XXXXXXXXXXxXxxxxxxxXXXXXXXXXXXXXXXXX',
    'XXXXXXXXXXXxX$&$$$$XXXXXXXXXXXXXXXXX',
    'XXXXXXXXXX&&$$+$$$$&$$XXXXXXXXXXXXXX',
    'XXXXXXXXX&&$$$x$$$$$$&$$XXXXXXXXXXXX',
    'XXXXXXXX&&&$+;;;+X$$$$$$$XXXXXXXXXXX',
    'XXXX$$$&&&+;;;;;;;;+$X$$$XXXXXXXXXXX',
    'XXX$$$$$&$;;;;;;;+$$$&$$&&XXXXXXXXXX',
    'XXX$$$$&&$X+xxx;;x$$$$$$&$&XXXXXXXXX',
    'XX$$$$$&&X++++;;:;;;;+$$$&$XXXXXXXXX',
    'XX$$$$$$&X;;:;+;:;;;;;&$X$$$XXXXXXXX',
    'XX$$$$$&&&+++;;;+;;+++$$$$$$XXXXXXXX',
    'X$$$$$$$&&$;;;xxxx;;;+&$$$X$$XXXXXXX',
    'XX$$$&&$$$&$+;;;;;;;+&&$X$X$$XXXXXXX',
    'X$$$$$$$$$&&++x+++xxX&&$$$$X$$XXXXX$',
    '$$$$&&&$$;Xx+;;;;;++xXx$$$$$$$$$$$$$',
    '$$$&$;::;::x+;;;;;;++xxX&&$$$$$$$$$$',
    ';::::::::::::+;;;;+++:++$$$$$;;;:$$$',
    ':::::::::::::::+;+++;;++;$$$$Xx+;::$',
    ':::::::::::::::::::;;;;;;;X$$$XXX:;:',
    '::::::::::::::::::::::::::;x$$$$x;;:',
    '::::::::::::::;::.::::::::::+$$$;+;:',
    ':::::::::::::::::;:::::::::::;$&&+::',
    ';;:;:::::::::::::;::::::::::::+$&;:;',
    ';;:;:::::::::::::::::::::::::::$&;;:',
    ';;:::::::::::::::::::::::::::::$$;;+',
    '',
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
      tabline = false,
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

function config.lualine()
  local ft_without_filename = {
    'toggleterm',
    '',
  }

  local ft_without_lsp = {
    'dashboard',
    'toggleterm',
    '',
  }

  local lsp_info = function()
    local clients = vim.lsp.get_clients()
    if next(clients) == nil then
      return 'no lsp'
    end

    local msg = ''
    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, vim.bo.filetype) ~= -1 then
        if client.name == 'null-ls' then
          msg = string.format('%s 󰟢', msg)
        else
          msg = string.format('%s %s', msg, client.name)
        end
      end
    end

    return msg
  end

  require('lualine').setup({
    options = {
      icons_enabled = true,
      theme = 'onedark',
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      disabled_filetypes = {
        statusline = {},
        tabline = {},
        winbar = {},
      },
      ignore_focus = {},
      always_divide_middle = true,
      globalstatus = false,
      refresh = {
        statusline = 1000,
        tabline = 1000,
        winbar = 1000,
      },
    },
    sections = {
      lualine_a = {
        { 'mode' },
        {
          function()
            return string.format('[%d]', vim.b.toggle_number)
          end,
          cond = function()
            return vim.bo.filetype == 'toggleterm'
          end,
        },
      },
      lualine_b = {
        'branch',
        'diff',
        'diagnostics',
        {
          lsp_info,
          cond = function()
            return not vim.tbl_contains(ft_without_lsp, vim.bo.filetype)
          end,
        },
      },
      lualine_c = {
        {
          'filename',
          cond = function()
            return not vim.tbl_contains(ft_without_filename, vim.bo.filetype)
          end,
        },
      },
      lualine_x = { 'encoding', 'fileformat', 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { 'filename' },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {
      lualine_a = {
        {
          'buffers',
          show_filename_only = true, -- Shows shortened relative path when set to false.
          hide_filename_extension = false, -- Hide filename extension when set to true.
          show_modified_status = true, -- Shows indicator when the buffer is modified.

          mode = 4,
          -- 0: Shows buffer name
          -- 1: Shows buffer index
          -- 2: Shows buffer name + buffer index
          -- 3: Shows buffer number
          -- 4: Shows buffer name + buffer number

          max_length = vim.o.columns * 2 / 3, -- Maximum width of buffers component,
          -- it can also be a function that returns
          -- the value of `max_length` dynamically.
          filetype_names = {
            TelescopePrompt = 'Telescope',
            dashboard = 'Dashboard',
            packer = 'Packer',
            fzf = 'FZF',
            alpha = 'Alpha',
          }, -- Shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )

          -- Automatically updates active buffer color to match color of other components (will be overidden if buffers_color is set)
          use_mode_colors = false,

          symbols = {
            modified = ' ●', -- Text to show when the buffer is modified
            alternate_file = '#', -- Text to show to identify the alternate file
            directory = '', -- Text to show when the buffer is a directory
          },
        },
      },
    },
    winbar = {},
    inactive_winbar = {},
    extensions = {},
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
      Insert = {
        guibg = '#1f1f1f',
      },
      NormalFloat = {
        guibg = '#1f1f1f',
      },
      winbar = {
        enabled = true,
        name_formatter = function(term) --  term: Terminal
          return term.name
        end,
      },
    },
  })

  local Terminal = require('toggleterm.terminal').Terminal
  local terms = require('toggleterm.terminal')

  local lazydocker = Terminal:new({
    hidden = true,
    direction = 'float',
    close_on_exit = true,
    Normal = {
      guibg = '#1f1f1f',
    },
    NormalFloat = {
      guibg = '#1f1f1f',
    },
    cmd = 'lazydocker',
  })

  local ipython = Terminal:new({
    hidden = true,
    direction = 'vertical',
    dir = 'git_dir',
    close_on_exit = true,
    Normal = {
      guibg = '#1f1f1f',
    },
    NormalFloat = {
      guibg = '#1f1f1f',
    },
    cmd = 'ipython',
  })

  local django_shell_plus = Terminal:new({
    hidden = true,
    dir = 'git_dir',
    direction = 'vertical',
    close_on_exit = true,
    Normal = {
      guibg = '#1f1f1f',
    },
    NormalFloat = {
      guibg = '#1f1f1f',
    },
    cmd = 'python manage.py shell_plus',
  })

  local commit_history = Terminal:new({
    hidden = true,
    direction = 'float',
    dir = 'git_dir',
    close_on_exit = true,
    cmd = 'git log --pretty=oneline -10 --no-merges',
    Normal = {
      guibg = '#1f1f1f',
    },
    NormalFloat = {
      guibg = '#1f1f1f',
    },
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

function config.notify()
  local notify = require('notify')

  -- Configure nvim-notify
  notify.setup({
    -- Animation style
    stages = 'fade_in_slide_out', -- Options: fade_in_slide_out, fade, slide, static
    -- Timeout for notifications in ms
    timeout = 3000,
    -- Background colour
    background_colour = '#000000',
    -- Icons for different log levels
    icons = {
      ERROR = '',
      WARN = '',
      INFO = '',
      DEBUG = '',
      TRACE = '✎',
    },
    -- Max width of notification window
    max_width = 80,
    -- Max height of notification window
    max_height = 10,
    -- Render function for messages
    render = 'default', -- Options: default, minimal, simple, compact
    -- Top down or bottom up
    top_down = true,
    -- Minimum level to show
    level = vim.log.levels.INFO,
    -- Function to execute on notification open
    on_open = nil,
    -- Function to execute on notification close
    on_close = nil,
  })

  -- Set nvim-notify as the default notification handler
  vim.notify = notify
end

return config
