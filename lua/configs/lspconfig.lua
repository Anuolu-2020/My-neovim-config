-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local util = require "lspconfig.util"

local nvlsp = require "nvchad.configs.lspconfig"

--Auto save group
local group = vim.api.nvim_create_augroup("autosave", {})

local map = vim.keymap.set

local function organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
  }
  vim.lsp.buf.execute_command(params)
end

-- local function go_to_source_definition()
--   local params = vim.lsp.util.make_position_params()
--   params.command = "typescript.goToSourceDefinition"
--   params.arguments = { params.textDocument.uri, params.position }
--   params.open = true
-- end

local function findAllFileReferences()
  local params = {
    command = "typescript.findAllFileReferences",
    arguments = { vim.uri_from_bufnr(0) },
    open = true,
  }
  vim.lsp.buf.execute_command(params)
end

-- EXAMPLE
local servers = {
  html = {},
  cssls = {},
  -- vtsls = {
  --   -- explicitly add default filetypes, so that we can extend
  --   -- them in related extras
  --   filetypes = {
  --     "javascript",
  --     "javascriptreact",
  --     "javascript.jsx",
  --     "typescript",
  --     "typescriptreact",
  --     "typescript.tsx",
  --   },
  --   settings = {
  --     complete_function_calls = true,
  --     vtsls = {
  --       enableMoveToFileCodeAction = true,
  --       autoUseWorkspaceTsdk = true,
  --       experimental = {
  --         maxInlayHintLength = 30,
  --         completion = {
  --           enableServerSideFuzzyMatch = true,
  --         },
  --       },
  --     },
  --     typescript = {
  --       updateImportsOnFileMove = { enabled = "always" },
  --       suggest = {
  --         completeFunctionCalls = true,
  --       },
  --       inlayHints = {
  --         enumMemberValues = { enabled = true },
  --         functionLikeReturnTypes = { enabled = true },
  --         parameterNames = { enabled = "literals" },
  --         parameterTypes = { enabled = true },
  --         propertyDeclarationTypes = { enabled = true },
  --         variableTypes = { enabled = false },
  --       },
  --     },
  --   },
  -- },
  ts_ls = {
    filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact", "html" },
    commands = {
      OrganizeImports = {
        organize_imports,
        description = "Organize Typescript Imports",
      },
    },
    on_attach = function(_, bufnr)
      -- map("n", "gD", go_to_source_definition, {
      --   buffer = bufnr,
      --   noremap = true,
      --   silent = true,
      --   desc = "Go to Source Definition",
      -- })

      map("n", "gR", findAllFileReferences, {
        buffer = bufnr,
        noremap = true,
        silent = true,
        desc = "File References",
      })

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
