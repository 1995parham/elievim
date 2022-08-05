local null_ls = require('null_ls')

return {
  null_ls.builtins.formatting.stylua,
  null_ls.builtins.formatting.sql_formatter,
  null_ls.builtins.formatting.jq,
  null_ls.builtins.formatting.gofumpt,
  null_ls.builtins.formatting.markdownlint,
  null_ls.builtins.formatting.black,
  null_ls.builtins.formatting.djlint,
  null_ls.builtins.formatting.taplo,

  null_ls.builtins.diagnostics.jsonlint,
  null_ls.builtins.diagnostics.luacheck,
  null_ls.builtins.diagnostics.pylint,
  -- null_ls.builtins.diagnostics.pyproject_flake8,
  null_ls.builtins.diagnostics.flake8,
  null_ls.builtins.diagnostics.djlint,
  null_ls.builtins.diagnostics.actionlint,
  null_ls.builtins.diagnostics.markdownlint,
}
