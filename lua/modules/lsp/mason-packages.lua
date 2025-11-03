-- packages that are installed automatically using mason.
-- each function groups tools related with a specific language,
-- and they all called using all method to list them together.
local runtime = require('core.runtime')
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
  local pkgs = {}

  -- bash-language-server requires Node.js
  if runtime.has_nodejs() then
    table.insert(pkgs, 'bash-language-server')
  end

  -- shfmt and shellcheck are standalone binaries
  table.insert(pkgs, 'shfmt')
  table.insert(pkgs, 'shellcheck')

  return pkgs
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
    -- 'stylua',
    'selene',
  }
end

function packages.vim()
  -- vim-language-server requires Node.js
  if runtime.has_nodejs() then
    return {
      'vim-language-server',
    }
  else
    return {}
  end
end

function packages.sql()
  return {
    'sql-formatter',
  }
end

function packages.json()
  local pkgs = { 'jq' } -- jq is a standalone binary

  -- json-lsp requires Node.js
  if runtime.has_nodejs() then
    table.insert(pkgs, 'json-lsp')
  end

  return pkgs
end

-- function packages.ansible()
--   return {
--     'ansible-language-server',
--   }
-- end

function packages.python()
  -- basedpyright requires Node.js (it's built with Node.js despite being a Python LSP)
  if runtime.has_nodejs() then
    return {
      -- install packages like mypy or pylint locally instead of
      -- globally so they can search virtualenv.
      -- 'mypy',
      -- 'pylint',
      -- 'isort',
      -- 'black',

      'basedpyright',
    }
  else
    return {}
  end
end

function packages.toml()
  return {
    'taplo',
  }
end

function packages.docker()
  local pkgs = { 'hadolint' } -- hadolint is a standalone binary

  -- dockerfile-language-server and docker-compose-language-service require Node.js
  if runtime.has_nodejs() then
    table.insert(pkgs, 'dockerfile-language-server')
    table.insert(pkgs, 'docker-compose-language-service')
  end

  return pkgs
end

function packages.markdown()
  -- markdownlint requires Node.js
  if runtime.has_nodejs() then
    return {
      'markdownlint',
    }
  else
    return {}
  end
end

function packages.jinja()
  -- djlint requires Python
  if runtime.has_python() then
    return {
      'djlint',
    }
  else
    return {}
  end
end

function packages.graphql()
  -- graphql-language-service-cli requires Node.js
  if runtime.has_nodejs() then
    return {
      'graphql-language-service-cli',
    }
  else
    return {}
  end
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
  local pkgs = {
    'editorconfig-checker',
    'impl',
    'misspell',
    'staticcheck',
    'vint',
    'ltex-ls', -- Java-based, standalone
    'kulala-fmt',
  }

  -- Node.js-dependent packages
  if runtime.has_nodejs() then
    table.insert(pkgs, 'prettierd')
    table.insert(pkgs, 'cspell')
    table.insert(pkgs, 'gh-actions-language-server')
  end

  return pkgs
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
