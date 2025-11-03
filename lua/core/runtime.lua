-- Runtime environment detection utilities
local M = {}

-- Cache the results to avoid repeated checks
local _cache = {}

-- Check if a command is available in PATH
local function is_executable(cmd)
  if _cache[cmd] ~= nil then
    return _cache[cmd]
  end

  local result = vim.fn.executable(cmd) == 1
  _cache[cmd] = result
  return result
end

-- Check if Node.js is available
function M.has_nodejs()
  return is_executable('node') or is_executable('nodejs')
end

-- Check if npm is available
function M.has_npm()
  return is_executable('npm')
end

-- Check if Python is available
function M.has_python()
  return is_executable('python') or is_executable('python3')
end

-- Check if pip is available
function M.has_pip()
  return is_executable('pip') or is_executable('pip3')
end

-- Get a summary of available runtimes
function M.summary()
  return {
    nodejs = M.has_nodejs(),
    npm = M.has_npm(),
    python = M.has_python(),
    pip = M.has_pip(),
  }
end

-- Print runtime availability (for debugging)
function M.print_summary()
  local summary = M.summary()
  print('Runtime Environment:')
  print('  Node.js: ' .. (summary.nodejs and '✓' or '✗'))
  print('  npm:     ' .. (summary.npm and '✓' or '✗'))
  print('  Python:  ' .. (summary.python and '✓' or '✗'))
  print('  pip:     ' .. (summary.pip and '✓' or '✗'))
end

-- Notify user about missing runtimes and their impact
function M.notify_missing_runtimes()
  local missing = {}
  local features = {}

  if not M.has_nodejs() then
    table.insert(missing, 'Node.js')
    table.insert(
      features,
      '  • LSP servers (bash, vim, json, dockerfile, graphql, python/basedpyright)'
    )
    table.insert(features, '  • Formatters (prettierd)')
    table.insert(features, '  • Linters (cspell, markdownlint)')
    table.insert(features, '  • GitHub Actions language server')
  end

  if not M.has_python() then
    table.insert(missing, 'Python')
    table.insert(features, '  • Jinja/Django linter and formatter (djlint)')
  end

  if #missing > 0 then
    local msg = string.format(
      'Neovim running in minimal mode. Missing: %s\n\nDisabled features:\n%s\n\nInstall the missing runtimes for full functionality.',
      table.concat(missing, ', '),
      table.concat(features, '\n')
    )

    vim.notify(msg, vim.log.levels.WARN, {
      title = 'Runtime Dependencies',
    })
  end
end

return M
