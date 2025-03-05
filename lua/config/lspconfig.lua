-- load defaults i.e lua_lsp
local lspconfig = require("lspconfig")
local util = require("lspconfig.util")
local lazyConfig = require("lazyvim.plugins.lsp.keymaps")

local M = {}
local map = vim.keymap.set

local function organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
  }
  vim.lsp.buf.execute_command(params)
end

local function go_to_source_definition()
  local params = vim.lsp.util.make_position_params()
  params.command = "typescript.goToSourceDefinition"
  params.arguments = { params.textDocument.uri, params.position }
  params.open = true

  vim.lsp.buf.execute_command(params)
end

local function on_attach(client, bufnr)
  -- Call LazyVim's default on_attach.
  lazyConfig.on_attach(client, bufnr)

  -- Add ts_ls specific mapping.
  map("n", "gD", go_to_source_definition, {
    buffer = bufnr,
    noremap = true,
    silent = true,
    desc = "Goto Source Definition",
  })
end

local servers = {
  cssls = {},
  ts_ls = {
    filetypes = { "ts", "js", "html" },
    commands = {
      OrganizeImports = {
        organize_imports,
        description = "Organize Imports",
      },
    },
    root_dir = function(fname)
      return util.root_pattern(".git")(fname)
        or util.root_pattern("package.json", "tsconfig.json", "jsconfig.json")(fname)
    end,
  },
  biome = {
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
  },
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = {
            vim.fn.expand("$VIMRUNTIME/lua"),
            vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
            vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types",
            vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
          },
          maxPreload = 100000,
          preloadFileSize = 10000,
        },
      },
    },
    filetypes = { "lua" },
  },
}

--"eslint",

-- disable semanticTokens
M.on_init = function(client, _)
  if client.supports_method("textDocument/semanticTokens") then
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

local open_floating_preview = util.open_floating_preview
function util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "rounded" -- Set border to rounded
  return open_floating_preview(contents, syntax, opts)
end

-- lsps with default config
for name, opts in pairs(servers) do
  opts.on_init = M.on_init
  opts.on_attach = on_attach
  opts.capabilities = M.capabilities

  require("lspconfig")[name].setup(opts)
end
