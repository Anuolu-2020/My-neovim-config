local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "cssls" },
    html = { "prettierd" },
    javascript = { "biome" },
    typescript = { "biome" },
    go = { "golines", "gofumpt", "goimports_reviser" },
    python = { "black" },
    clang = { "clang_format" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    --timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
