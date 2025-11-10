-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local nvlsp = require "nvchad.configs.lspconfig"

nvlsp.capabilities = vim.lsp.protocol.make_client_capabilities()

--Auto save group
local group = vim.api.nvim_create_augroup("autosave", {})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf
    if not client then
      return
    end

    -- Run NvChad default on_attach logic:
    if nvlsp.on_attach then
      nvlsp.on_attach(client, bufnr)
    end
  end,
})

-- local map = vim.keymap.set

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
  html = {
    cmd = { "vscode-html-language-server", "--stdio" },
    filetypes = { "html", "htm", "svelte", "astro" },
  },
  cssls = {
    cmd = { "vscode-css-language-server", "--stdio" },
    filetypes = { "css", "scss", "less" },
  },
  ts_ls = {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact", "html" },
    ---@type lsp.ClientCapabilities
    capabilities = {
      textDocument = {
        rename = {
          prepareSupport = false,
        },
      },
    },
    on_attach = function(client, bufnr)
      -- nvlsp.on_attach(client, bufnr)
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
    root_markers = { ".git", "package.json", "tsconfig.json", "jsconfig.json" },
  },
  gopls = {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl", "template" },
    -- root_dir = util.root_pattern("go.mod", ".git", "go.work"),
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
    cmd = { "pyright-langserver", "--stdio" },
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
    cmd = { "ruff-lsp" },
    filetypes = { "python" },
  },
  htmx = {
    cmd = { "htmx-lsp" },
    filetypes = { "html" },
  },
  tailwindcss = {
    cmd = { "tailwindcss-language-server", "--stdio" },
    filetypes = { "css", "tmpl", "html" },
  },
  zls = {
    cmd = { "zls" },
    on_attach = function(client, bufnr)
      nvlsp.on_attach(client, bufnr)
    end,
    filetypes = { "zig" },
    settings = {
      -- zls = {
      --   zig_exe_path = "/home/ogunleye/zigup/bin/zig",
      -- },
      warn_style = true,
      inlay_hints_show_variable_type_hints = true,
    },
    root_markers = { ".git", "build.zig", "build.zig.lock", "zig-cache" },
  },
  biome = {
    cmd = { "biome-language-server", "--stdio" },
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
    root_markers = { ".biome.json", ".biome.jsonc" },
    single_file_support = false,
  },
  yamlls = {
    cmd = { "yaml-language-server", "--stdio" },
    filetypes = { "yaml", "yml" },
  },
  -- jdtls = {},
  -- lua_ls = {
  --   filetypes = { "lua" },
  -- },
  templ = {
    cmd = { "templ-lsp", "--stdio" },
    filetypes = { "templ" },
  },
  emmet_ls = {
    cmd = { "emmet-ls", "--stdio" },
    filetypes = { "templ", "html" },
  },
  asm_lsp = {
    cmd = { "asm-lsp", "--stdio" },
    filetypes = { "asm" },
  },
  clangd = {
    cmd = { "clangd", "--background-index" },
    filetypes = { "c", "cpp", "objc", "objcpp" },
    on_attach = function(client, _)
      client.server_capabilities.signatureHelpProvider = false
    end,
  },
  kotlin_language_server = {
    cmd = { "kotlin-language-server", "--stdio" },
    filetypes = { "kotlin", "kt", "kts" },
  },
  prismals = {
    cmd = { "prisma-language-server", "--stdio" },
    filetypes = { "prisma" },
    capabilities = {
      textDocument = {
        foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
        },
      },
    },
    on_attach = function(client, bufnr)
      nvlsp.on_attach(client, bufnr)
    end,
    settings = {
      prisma = {
        prismaFmtBinPath = "", -- Ensure prisma-fmt is in your PATH
      },
    },
  },
}

for name, opts in pairs(servers) do
  -- opts.on_init = nvlsp.on_init
  -- -- Only set default on_attach if a custom one isn't already provided
  -- if not opts.on_attach then
  --   opts.on_attach = nvlsp.on_attach
  -- end
  -- opts.capabilities = nvlsp.capabilities

  opts.capabilities = vim.tbl_deep_extend("force", nvlsp.capabilities, opts.capabilities or {})

  vim.lsp.enable(name)
  vim.lsp.config(name, opts)
  -- require("lspconfig")[name].setup(opts)
end
