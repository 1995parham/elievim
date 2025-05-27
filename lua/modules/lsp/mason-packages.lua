-- packages that are installed automatically using mason.
-- each function groups tools related with a specific language,
-- and they all called using all method to list them together.
local packages = {}

function packages.go()
  if vim.fn.executable('go') == 1 then
    return {
      'gopls',
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
  }
end

function packages.c()
  if vim.fn.executable('gcc') == 1 then
    return {
      'clangd',
    }
  else
    return {}
  end
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
    'json-lsp',
  }
end

-- function packages.ansible()
--   return {
--     'ansible-language-server',
--   }
-- end

function packages.python()
  return {
    -- install packages like mypy or pylint locally instead of
    -- globally so they can search virtualenv.
    -- 'mypy',
    -- 'pylint',
    -- 'isort',
    -- 'black',

    'basedpyright',
    'ty',
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
    'docker-compose-language-service',
    'hadolint',
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

function packages.graphql()
  return {
    'graphql-language-service-cli',
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
    'prettierd',
    'cspell',
    'kulala-fmt',
  }
end

function packages.all()
  local pkgs = {}

  for name, packages_gen in pairs(packages) do
    if name ~= 'all' then
      for _, pkg in ipairs(packages_gen()) do
        table.insert(pkgs, pkg)
      end
    end
  end

  return pkgs
end

return packages
