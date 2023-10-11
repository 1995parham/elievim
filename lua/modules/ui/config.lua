local config = {}

function config.naz()
  require('naz')
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

function config.noice()
  require('noice').setup({
    cmdline = {
      enabled = false,
      view = 'cmdline',
    },
    messages = {
      enabled = false,
    },
    views = {
      hover = {
        border = {
          style = 'double',
        },
        win_options = {
          winblend = 10,
          winhighlight = 'Normal:Normal,FloatBorder:SpecialChar',
        },
      },
    },
    lsp = {
      progress = {
        enabled = true,
        -- Lsp Progress is formatted using the builtins for lsp_progress. See config.format.builtin
        -- See the section on formatting for more details on how to customize.
        format = 'lsp_progress',
        format_done = 'lsp_progress_done',
        throttle = 1000 / 30, -- frequency to update lsp progress message
        view = 'notify',
      },
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true,
      },
      hover = {
        enabled = true,
      },
      message = {
        -- Messages shown by lsp servers
        enabled = true,
        view = 'notify',
        opts = {},
      },
      -- defaults for hover and signature help
      documentation = {
        view = 'hover',
        ---@type NoiceViewOptions
        opts = {
          lang = 'markdown',
          replace = true,
          render = 'plain',
          format = { '{message}' },
          win_options = { concealcursor = 'n', conceallevel = 3 },
        },
      },
    },
    markdown = {
      hover = {
        ['|(%S-)|'] = vim.cmd.help, -- vim help links
        ['%[.-%]%((%S-)%)'] = require('noice.util').open, -- markdown links
      },
      highlights = {
        ['|%S-|'] = '@text.reference',
        ['@%S+'] = '@parameter',
        ['^%s*(Parameters:)'] = '@text.title',
        ['^%s*(Return:)'] = '@text.title',
        ['^%s*(See also:)'] = '@text.title',
        ['{%S-}'] = '@parameter',
      },
    },
    -- you can enable a preset for easier configuration
    presets = {
      bottom_search = true, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false, -- add a border to hover docs and signature help
    },
  })
end

return config
