-- author: glepnr https://github.com/glepnir
-- date: 2022-07-02
-- License: MIT

local status_ok, galaxyline = pcall(require, 'galaxyline')
if not status_ok then
  return
end

local colors = {
  bg = '#525252',
  black = '#2c2c2c',
  yellow = '#fabd2f',
  cyan = '#00e6e6',
  darkblue = '#081633',
  green = '#afd700',
  orange = '#FF8800',
  purple = '#5d4d7a',
  magenta = '#d16d9e',
  grey = '#c0c0c0',
  blue = '#0087d7',
  red = '#ec5f67',
  violet = '#ee82ee',
}
local condition = require('galaxyline.condition')
local gls = galaxyline.section
galaxyline.short_line_list = { 'NvimTree', 'vista', 'dbui', 'packer' }

gls.left[1] = {
  RainbowRed = {
    provider = function()
      return '▊ '
    end,
    highlight = { colors.orange, colors.bg },
  },
}

gls.left[2] = {
  ViMode = {
    provider = function()
      -- auto change color according the vim mode
      local mode_color = {
        ['!'] = colors.red,
        [''] = colors.blue,
        [''] = colors.orange,
        ['r?'] = colors.cyan,
        c = colors.magenta,
        ce = colors.red,
        cv = colors.red,
        i = colors.green,
        ic = colors.yellow,
        n = colors.red,
        no = colors.red,
        r = colors.cyan,
        R = colors.violet,
        rm = colors.cyan,
        Rv = colors.violet,
        s = colors.orange,
        S = colors.orange,
        t = colors.red,
        v = colors.blue,
        V = colors.blue,
      }
      vim.api.nvim_command('hi GalaxyViMode guifg=' .. mode_color[vim.fn.mode()] .. ' guibg=' .. colors.bg)
      local mode_name = {
        n = 'NORMAL',
        i = 'INSERT',
        c = 'COMMAND',
        v = 'VISUAL',
        V = 'VISUAL LINE',
        R = 'REPLACE',
        Rv = 'REPLACE VISUAL',
        [''] = 'VISUAL BLOCK',
      }
      return string.format('%s ', mode_name[vim.fn.mode()] or '-')
    end,
  },
}

gls.left[3] = {
  FileSize = {
    condition = condition.buffer_not_empty,
    highlight = { colors.fg, colors.bg },
    provider = 'FileSize',
  },
}

gls.left[4] = {
  FileIcon = {
    condition = condition.buffer_not_empty,
    highlight = { require('galaxyline.provider_fileinfo').get_file_icon_color, colors.bg },
    provider = 'FileIcon',
  },
}

gls.left[5] = {
  FileName = {
    condition = condition.buffer_not_empty,
    highlight = { colors.fg, colors.bg, 'bold' },
    provider = 'FileName',
  },
}

gls.left[6] = {
  LineInfo = {
    highlight = { colors.fg, colors.bg },
    provider = 'LineColumn',
    separator = ' ',
    separator_highlight = { 'NONE', colors.bg },
  },
}

gls.left[7] = {
  PerCent = {
    highlight = { colors.fg, colors.bg, 'bold' },
    provider = 'LinePercent',
    separator = ' ',
    separator_highlight = { 'NONE', colors.bg },
  },
}

gls.left[8] = {
  DiagnosticError = {
    highlight = { colors.red, colors.bg },
    icon = '  ',
    provider = 'DiagnosticError',
  },
}

gls.left[9] = {
  DiagnosticWarn = {
    highlight = { colors.yellow, colors.bg },
    icon = '  ',
    provider = 'DiagnosticWarn',
  },
}

gls.left[10] = {
  DiagnosticHint = {
    highlight = { colors.cyan, colors.bg },
    icon = '  ',
    provider = 'DiagnosticHint',
  },
}

gls.left[11] = {
  DiagnosticInfo = {
    highlight = { colors.blue, colors.bg },
    icon = '  ',
    provider = 'DiagnosticInfo',
  },
}

gls.left[12] = {
  FilePath = {
    condition = condition.buffer_not_empty,
    highlight = { colors.fg, colors.bg, 'italic' },
    provider = 'FilePath',
  },
}

gls.mid[1] = {
  ShowLspClient = {
    condition = function()
      local file_types_without_lsp = {
        ['dashboard'] = true,
        [''] = true,
      }

      if file_types_without_lsp[vim.bo.filetype] then
        return false
      end
      return true
    end,
    highlight = { colors.yellow, colors.bg, 'bold' },
    icon = ' LSP:',
    provider = function(msg)
      msg = msg or 'No Active Lsp'
      local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
      local clients = vim.lsp.get_active_clients()
      if next(clients) == nil then
        return msg
      end

      msg = ''
      for _, client in ipairs(clients) do
        local filetypes = client.config.filetypes
        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
          if client.name == 'null-ls' then
            msg = string.format('%s ﳠ', msg)
          else
            msg = string.format('%s %s', msg, client.name)
          end
        end
      end

      return msg
    end,
  },
}

gls.right[1] = {
  FileEncode = {
    condition = condition.hide_in_width,
    highlight = { colors.green, colors.bg, 'bold' },
    provider = 'FileEncode',
    separator = ' ',
    separator_highlight = { 'NONE', colors.bg },
  },
}

gls.right[2] = {
  FileFormat = {
    condition = condition.hide_in_width,
    highlight = { colors.green, colors.bg, 'bold' },
    provider = 'FileFormat',
    separator = ' ',
    separator_highlight = { 'NONE', colors.bg },
  },
}

gls.right[3] = {
  GitIcon = {
    provider = function()
      return '  '
    end,
    condition = condition.check_git_workspace,
    highlight = { colors.violet, colors.bg, 'bold' },
    separator = ' ',
    separator_highlight = { 'NONE', colors.bg },
  },
}

gls.right[4] = {
  GitBranch = {
    condition = condition.check_git_workspace,
    highlight = { colors.violet, colors.bg, 'bold' },
    separator = ' ',
    separator_highlight = { 'NONE', colors.bg },
    provider = 'GitBranch',
  },
}

gls.right[5] = {
  DiffAdd = {
    condition = condition.hide_in_width,
    highlight = { colors.green, colors.bg },
    icon = '  ',
    provider = 'DiffAdd',
    separator = ' ',
    separator_highlight = { 'NONE', colors.bg },
  },
}

gls.right[6] = {
  DiffModified = {
    condition = condition.hide_in_width,
    highlight = { colors.orange, colors.bg },
    icon = ' 柳',
    provider = 'DiffModified',
    separator = ' ',
    separator_highlight = { 'NONE', colors.bg },
  },
}

gls.right[7] = {
  DiffRemove = {
    condition = condition.hide_in_width,
    highlight = { colors.red, colors.bg },
    icon = '  ',
    provider = 'DiffRemove',
    separator = ' ',
    separator_highlight = { 'NONE', colors.bg },
  },
}

gls.right[8] = {
  TreeSitter = {
    provider = function()
      local ok, nt = pcall(require, 'nvim-treesitter')
      if not ok then
        return
      end

      return nt.statusline({
        indicator_size = 100,
        type_patterns = { 'class', 'function', 'method' },
        transform_fn = function(line)
          return line:gsub('%s*[%[%(%{]*%s*$', '')
        end,
        separator = ' -> ',
      })
    end,
    highlight = { colors.grey, colors.bg },
    separator = ' ',
    separator_highlight = { 'NONE', colors.bg },
  },
}

gls.right[9] = {
  RainbowBlue = {
    provider = function()
      return ' ▊'
    end,
    highlight = { colors.orange, colors.bg },
    separator = ' ',
    separator_highlight = { 'NONE', colors.bg },
  },
}

gls.short_line_left[1] = {
  BufferType = {
    highlight = { colors.blue, colors.bg, 'bold' },
    provider = 'FileTypeName',
    separator = ' ',
    separator_highlight = { 'NONE', colors.bg },
  },
}

gls.short_line_left[2] = {
  SFileName = {
    condition = condition.buffer_not_empty,
    highlight = { colors.fg, colors.bg, 'bold' },
    provider = 'SFileName',
  },
}

gls.short_line_right[1] = {
  BufferIcon = {
    highlight = { colors.fg, colors.bg },
    provider = 'BufferIcon',
  },
}
