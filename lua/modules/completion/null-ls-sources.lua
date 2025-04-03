-- https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md
local null_ls = require('null-ls')
-- local cspell = require('cspell')

return {
  -- An opinionated code formatter for Lua.
  null_ls.builtins.formatting.stylua,
  -- A whitespace formatter for different query languages
  null_ls.builtins.formatting.sql_formatter,
  -- Enforce a stricter format than gofmt, while being backwards compatible.
  -- That is, gofumpt is happy with a subset of the formats that gofmt is happy with.
  null_ls.builtins.formatting.gofumpt,
  -- The uncompromising Python code formatter
  null_ls.builtins.formatting.black.with({
    condition = function()
      return vim.fn.executable('black') == 1
    end,
    extra_args = function(params)
      local config = vim.fs.find('black.toml', {
        upward = false,
        path = params.root,
      })
      if #config > 0 then
        return {
          '--config',
          config[0],
        }
      end
      return {}
    end,
  }),
  -- Python utility / library to sort imports alphabetically and automatically separate them into sections and by type.
  null_ls.builtins.formatting.isort.with({
    condition = function()
      return vim.fn.executable('isort') == 1
    end,
  }),
  -- ✨ 📜 🪄 ✨ HTML Template Linter and Formatter.
  null_ls.builtins.formatting.djlint,
  -- A shell parser, formatter, and interpreter with bash support.
  null_ls.builtins.formatting.shfmt,
  -- prettier, as a daemon, for ludicrous formatting speed.
  null_ls.builtins.formatting.prettierd,

  null_ls.builtins.diagnostics.selene,
  -- cspell.diagnostics.with({
  --  diagnostics_postprocess = function(diagnostic)
  --    diagnostic.severity = vim.diagnostic.severity['HINT']
  --  end,
  -- }),
  -- cspell.code_actions,
  null_ls.builtins.diagnostics.mypy.with({
    method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
    condition = function()
      return vim.fn.executable('mypy') == 1
    end,
  }),
  null_ls.builtins.diagnostics.pylint.with({
    method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
    condition = function()
      return vim.fn.executable('pylint') == 1
    end,
  }),
  -- ✨ 📜 🪄 ✨ HTML Template Linter and Formatter.
  null_ls.builtins.diagnostics.djlint,
  -- Actionlint is a static checker for GitHub Actions workflow files.
  null_ls.builtins.diagnostics.actionlint,
  -- A smarter Dockerfile linter that helps you build best practice Docker images.
  null_ls.builtins.diagnostics.hadolint,
  -- A Go linter aggregator.
  null_ls.builtins.diagnostics.golangci_lint,
  -- null_ls.builtins.diagnostics.shellcheck,
  null_ls.builtins.formatting.just,
}
