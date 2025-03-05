local options = {
  formatters_by_ft = {
    -- lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    javascript = { "biome" },
    typescript = { "biome" },
    --go = { "golines", "gofumpt" },
    python = { "black" },
    clang = { "clang_format" },
    json = { "biome" },
    yaml = { "yamlfmt" },
    templ = { "templ" },
    asm = { "asmfmt" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    -- timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
