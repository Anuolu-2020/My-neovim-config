-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local util = require "lspconfig.util"

local nvlsp = require "nvchad.configs.lspconfig"

--Auto save group
local group = vim.api.nvim_create_augroup("autosave", {})

local map = vim.keymap.set

local function organize_imports(client, bufnr)
  vim.api.nvim_create_user_command("OrganizeImports", function()
    client:exec_cmd({
      title = "Organize Imports",
      command = "_typescript.organizeImports",
      arguments = { vim.api.nvim_buf_get_name(bufnr) },
    }, { bufnr = bufnr })
  end, {})
end

-- local function go_to_source_definition()
--   local params = vim.lsp.util.make_position_params()
--   params.command = "typescript.goToSourceDefinition"
--   params.arguments = { params.textDocument.uri, params.position }
--   params.open = true
-- end

-- local function findAllFileReferences(client)
--   client:exec_cmd {
--     title = "Typescript Find All File References",
--     command = "_typescript.findAllFileReferences",
--     arguments = { vim.uri_from_bufnr(0) },
--     open = true,
--   }
-- end

-- EXAMPLE
local servers = {
  html = {},
  cssls = {},
  ts_ls = {
    filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact", "html" },
    on_attach = function(client, bufnr)
      nvlsp.on_attach(client, bufnr)
      -- map("n", "gD", go_to_source_definition, {
      --   buffer = bufnr,
      --   noremap = true,
      --   silent = true,
      --   desc = "Go to Source Definition",
      -- })

      organize_imports(client, bufnr)

      -- vim.keymap.set("n", "<leader>oi", function()
      --   organize_imports(bufnr)
      -- end, { noremap = true, silent = true, buffer = bufnr })

      -- map("n", "gR", function()
      --   findAllFileReferences(client)
      -- end, {
      --   buffer = bufnr,
      --   noremap = true,
      --   silent = true,
      --   desc = "File References",
      -- })

      -- -- vim.notify("AutoSave presave", vim.log.levels.INFO)
    end,
    root_dir = function(fname)
      return util.root_pattern ".git"(fname)
        or util.root_pattern("package.json", "tsconfig.json", "jsconfig.json")(fname)
    end,
  },
  gopls = {
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
    on_attach = function(client, bufnr)
      -- Call NVChad's default on_attach to set keymaps, etc.
      nvlsp.on_attach(client, bufnr)

      -- Trigger the organize imports action after the auto-save plugin saves the file
      vim.api.nvim_create_autocmd("User", {
        pattern = "AutoSaveWritePost", -- Hook into the auto-save event
        -- buffer = bufnr,
        group = group,
        callback = function()
          vim.lsp.buf.code_action {
            context = {
              only = { "source.organizeImports" },
              diagnostics = {},
            },
            apply = true,
          }
          vim.lsp.buf.code_action {
            context = { only = { "source.fixAll" }, diagnostics = {} },
            apply = true,
          }

          -- vim.notify("AutoSave presave", vim.log.levels.INFO)
        end,
      })
    end,
  },
  pyright = {
    filetypes = { "python" },
    settings = {
      pyright = {
        disableOrganizeImports = false,
        analysis = {
          useLibraryCodeForTypes = true,
          autoSearchPaths = true,
          diagnosticMode = "workspace",
          autoImportCompletions = true,
        },
      },
    },
  },
  --linting for python
  ruff = {
    filetypes = { "python" },
  },
  htmx = {
    filetypes = { "html" },
  },
  tailwindcss = {
    filetypes = { "css", "tmpl", "html" },
  },
  zls = {
    filetypes = { "zig" },
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
  yamlls = {
    filetypes = { "yaml", "yml" },
  },
  -- jdtls = {},
  -- lua_ls = {
  --   filetypes = { "lua" },
  -- },
  templ = {
    filetypes = { "templ" },
  },
  emmet_ls = {
    filetypes = { "templ", "html" },
  },
  asm_lsp = {
    filetypes = { "asm" },
  },
  clangd = {
    on_attach = function(client, _)
      client.server_capabilities.signatureHelpProvider = false
    end,
  },
}

for name, opts in pairs(servers) do
  opts.on_init = nvlsp.on_init
  -- Only set default on_attach if a custom one isn't already provided
  if not opts.on_attach then
    opts.on_attach = nvlsp.on_attach
  end
  opts.capabilities = nvlsp.capabilities

  require("lspconfig")[name].setup(opts)
end
