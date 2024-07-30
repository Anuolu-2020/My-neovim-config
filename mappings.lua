local M = {}

M.dap = {
  plugin = true,
  n = {
    ["<leader>db"] = {
      "<cmd> DapToggleBreakpoint <CR>",
      "Add breakpoint at line",
    },
    ["<leader>dus"] = {
      function()
        local widgets = require "dap.ui.widgets"
        local sidebar = widgets.sidebar(widgets.scopes)
        sidebar.open()
      end,
      "Open debugging sidebar",
    },
    --space d and r to start or continue the debugger for cpp
    ["<leader>dr"] = {
      "<cmd> DapContinue <CR>",
      "Start or continue the debugger",
    },
  },
}

M.dap_go = {
  plugin = true,
  n = {
    ["<leader>dgt"] = {
      function()
        require("dap-go").debug_test()
      end,
      "Debug go test",
    },
    ["<leader>dgl"] = {
      function()
        require("dap-go").debug_last()
      end,
      "Debug last go test",
    },
  },
}

M.gopher = {
  plugin = true,
  n = {
    ["<leader>gsj"] = {
      "<cmd> GoTagAdd json <CR>",
      "Add json struct tags",
    },
    ["<leader>gsy"] = {
      "<cmd> GoTagAdd yaml <CR>",
      "Add yaml struct tags",
    },
  },
}

--M.general = {
--n = {
--["<C-h>"] = { "<cmd> TmuxNavigateLeft<CR>", "window left" },
--["<C-l>"] = { "<cmd> TmuxNavigateRight<CR>", "window right" },
--["<C-j>"] = { "<cmd> TmuxNavigateDown<CR>", "window down" },
--["<C-k>"] = { "<cmd> TmuxNavigateUp<CR>", "window up" },
--},
--}

M.dap_python = {
  plugin = true,
  n = {
    ["<leader>dpr"] = {
      function()
        require("dap-python").test_method()
      end,
    },
  },
}

-- Lua
vim.keymap.set("n", "<leader>oe", function()
  require("trouble").toggle()
end)
vim.keymap.set("n", "<leader>ow", function()
  require("trouble").toggle "workspace_diagnostics"
end)
vim.keymap.set("n", "<leader>od", function()
  require("trouble").toggle "document_diagnostics"
end)
vim.keymap.set("n", "<leader>qf", function()
  require("trouble").toggle "quickfix"
end)
vim.keymap.set("n", "<leader>ll", function()
  require("trouble").toggle "loclist"
end)
vim.keymap.set("n", "gR", function()
  require("trouble").toggle "lsp_references"
end)

return M
