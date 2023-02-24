local packages = {}

function packages.go()
  if vim.fn.executable('go') == 1 then
    return {
      'gopls',
      'golangci-lint-langserver',
      'json-to-struct',
      'gofumpt',
      'gotests',
      'gomodifytags',
    }
  else
    return {}
  end
end

function packages.shell()
  return {
    'bash-language-server',
    'shfmt',
    'shellcheck',
    'shellcheck',
  }
end

function packages.lua()
  return {
    'lua-language-server',
    'stylua',
    'selene',
  }
end

function packages.vim()
  return {
    'vim-language-server',
  }
end

function packages.sql()
  return {
    'sql-formatter',
  }
end

function packages.json()
  return {
    'jq',
  }
end

function packages.ansible()
  return {
    'ansible-language-server',
  }
end

function packages.python()
  return {
    -- install packages like mypy or pylint locally instead of
    -- globally so they can search virtualenv.

    -- 'mypy',
    'pyright',
    -- 'pylint',
    'flake8',
    'black',
  }
end

function packages.toml()
  return {
    'taplo',
  }
end

function packages.docker()
  return {
    'dockerfile-language-server',
  }
end

function packages.markdown()
  return {
    'markdownlint',
  }
end

function packages.jinja()
  return {
    'djlint',
  }
end

function packages.rust()
  if vim.fn.executable('rustc') == 1 then
    return {
      'rust-analyzer',
    }
  else
    return {}
  end
end

function packages.java()
  if vim.fn.executable('javac') == 1 then
    return {
      -- 'groovy-language-server',
    }
  else
    return {}
  end
end

function packages.etc()
  return {
    'editorconfig-checker',
    'impl',
    'misspell',
    'staticcheck',
    'vint',
    'ltex-ls',
    'prettier',
  }
end

function packages.all()
  local pkgs = {}

  for name, value in pairs(packages) do
    if name ~= 'all' then
      for _, pkg in ipairs(value()) do
        table.insert(pkgs, pkg)
      end
    end
  end

  return pkgs
end

return packages
