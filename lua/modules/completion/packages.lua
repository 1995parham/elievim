local packages = {}

packages.go = {
  'gopls',
  'golangci-lint-langserver',
  'json-to-struct',
  'gofumpt',
  'gotests',
  'gomodifytags',
}

packages.shell = {
  'bash-language-server',
  'shfmt',
  'shellcheck',
  'shellcheck',
}

packages.lua = {
  'lua-language-server',
  'stylua',
  'luacheck',
}

packages.vim = {
  'vim-language-server',
}

packages.sql = {
  'sql-formatter',
}

packages.json = {
  'jq',
}

packages.ansible = {
  'ansible-language-server',
}

packages.python = {
  -- install packages like mypy or pylint locally instead of
  -- globally so they can search virtualenv.

  -- 'mypy',
  'pyright',
  -- 'pylint',
  'flake8',
  'black',
}

packages.toml = {
  'taplo',
}

packages.docker = {
  'dockerfile-language-server',
}

packages.markdown = {
  'markdownlint',
}

packages.jinja = {
  'djlint',
}

packages.rust = {
  'rust-analyzer',
}

packages.java = {
  'groovy-language-server',
}

packages.etc = {
  'editorconfig-checker',
  'impl',
  'misspell',
  'staticcheck',
  'vint',
  'ltex-ls',
}

function packages.all()
  local pkgs = {}

  for name, value in pairs(packages) do
    if name ~= 'all' then
      for _, pkg in ipairs(value) do
        table.insert(pkgs, pkg)
      end
    end
  end

  return pkgs
end

return packages
