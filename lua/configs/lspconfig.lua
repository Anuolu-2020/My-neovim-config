-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"
local util = require "lspconfig/util"
--local nvlsp = require "nvchad.configs.lspconfig"

--Auto save group
local group = vim.api.nvim_create_augroup("autosave", {})

local M = {}
local map = vim.keymap.set

-- EXAMPLE
local servers =
  { "cssls", "ts_ls", "gopls", "pyright", "ruff_lsp", "htmx", "tailwindcss", "zls", "biome", "yamlls", "jdtls" }

--"eslint",

-- export on_attach & capabilities
M.on_attah = function(_, bufnr)
  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc }
  end

  map("n", "gh", vim.lsp.buf.declaration, opts "Go to declaration")
  map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
  map("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")
  map("n", "K", vim.lsp.buf.hover, opts "Show hover information")
  map("n", "<leader>lh", vim.lsp.buf.signature_help, opts "Show signature help")
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")
  map("n", "<leader>rr", vim.lsp.buf.rename, { desc = "Rename symbol" })
  --map("n", "gh", vim.lsp.buf.hover, opts "hover information")

  -- New mappings for linting errors
  map("n", "gn", vim.diagnostic.goto_next, opts "Go to next diagnostic")
  map("n", "gp", vim.diagnostic.goto_prev, opts "Go to previous diagnostic")

  map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts "List workspace folders")

  map("n", "<leader>gd", vim.lsp.buf.type_definition, opts "Go to type definition")

  map("n", "<leader>ra", function()
    require "nvchad.lsp.renamer"()
  end, opts "NvRenamer")

  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts "Code action")
  map("n", "gr", vim.lsp.buf.references, opts "Show references")
end

-- disable semanticTokens
M.on_init = function(client, _)
  if client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

vim.api.nvim_command "MasonToolsInstall"

local open_floating_preview = util.open_floating_preview
function util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "rounded" -- Set border to rounded
  return open_floating_preview(contents, syntax, opts)
end

M.defaults = function()
  dofile(vim.g.base46_cache .. "lsp")
  require("nvchad.lsp").diagnostic_config()

  require("lspconfig").lua_ls.setup {
    on_attach = M.on_attach,
    capabilities = M.capabilities,
    on_init = M.on_init,

    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = {
            vim.fn.expand "$VIMRUNTIME/lua",
            vim.fn.expand "$VIMRUNTIME/lua/vim/lsp",
            vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
            vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
          },
          maxPreload = 100000,
          preloadFileSize = 10000,
        },
      },
    },
  }
end

local function organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
  }
  vim.lsp.buf.execute_command(params)
end

-- lsps with default config
for _, lsp in ipairs(servers) do
  if lsp ~= "jdtls" then
    lspconfig[lsp].setup {
      on_attach = M.on_attach,
      on_init = M.on_init,
      capabilities = M.capabilities,
    }
  end
end

lspconfig.ts_ls.setup {
  filetypes = { "ts", "js", "html" },
  commands = {
    OrganizeImports = {
      organize_imports,
      description = "Organize Imports",
    },
  },
}

lspconfig.gopls.setup {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl", "template" },
  root_dir = util.root_pattern("go.mod", ".git", "go.work"),
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
  on_attach = function()
    -- Trigger the organize imports action after the auto-save plugin saves the file
    vim.api.nvim_create_autocmd("User", {
      pattern = "AutoSaveWritePost", -- Hook into the auto-save event
      --buffer = bufnr,
      group = group,
      callback = function()
        vim.lsp.buf.code_action {
          context = {
            only = { "source.organizeImports" },
            diagnostics = {},
          },
          apply = true,
        }
      end,
    })
  end,
}

lspconfig.yamlls.setup {
  filetypes = { "yaml", "yml" },
}

lspconfig.pyright.setup {
  filetypes = { "python" },
}

--linting for python
lspconfig.ruff_lsp.setup {
  filetypes = { "python" },
}

lspconfig.tailwindcss.setup {
  filetypes = { "css", "tmpl", "html" },
}

lspconfig.htmx.setup {
  filetypes = { "html" },
}

lspconfig.zls.setup {
  filetypes = { "zig" },
}

lspconfig.biome.setup {
  filetypes = {
    "javascript",
    "javascriptreact",
    "json",
    "jsonc",
    "typescript",
    "typescript.tsx",
    "typescriptreact",
    "astro",
    "svelte",
    "vue",
    "css",
  },
  root_dir = util.root_pattern("biome.json", "biome.jsonc"),
  single_file_support = false,
}

lspconfig.clangd.setup {
  on_attach = function(client, bufnr)
    client.server_capabilities.signatureHelpProvider = false
    M.on_attach(client, bufnr)
  end,
  capabilities = M.capabilities,
}

lspconfig.jdtls.setup {
  settings = {
    java = {
      configuration = {
        runtimes = {
          {
            name = "JavaSE-21",
            path = "/usr/lib/jvm/jdk-21.0.5-oracle-x64",
            default = true,
          },
        },
      },
    },
  },
}

-- configuring single server, example: typescript
-- lspconfig.ts_ls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
