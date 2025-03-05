return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require("config.conform"),
  },
  {
    "okuuva/auto-save.nvim",
    cmd = "ASToggle", -- optional for lazy loading on command
    event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events
    opts = {
      -- noautocmd = true
    },
  },
  -- {
  --   "neovim/nvim-lspconfig",
  --   event = "VeryLazy",
  --   config = function()
  --     require("config.lspconfig")
  --   end,
  -- },
}
