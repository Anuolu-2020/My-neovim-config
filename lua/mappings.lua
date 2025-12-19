require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })

map("i", "jk", "<ESC>")

-- blankline
map("n", "<leader>cc", function()
  local config = { scope = {} }
  config.scope.exclude = { language = {}, node_tpe = {} }
  config.scope.include = { node_type = {} }
  local node = require("ibl.scope").get(vim.api.nvim_get_current_buf(), config)

  if node then
    local start_row, _, end_row, _ = node:range()
    if start_row ~= end_row then
      vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start_row + 1, 0 })
      vim.api.nvim_feedkeys("_", "n", true)
    end
  end
end, { desc = "blankline jump to current context" })

-- DAP keymappings
map("n", "<leader>db", "<cmd> DapToggleBreakpoint <CR>", { noremap = true, desc = "Add breakpoint at line" })
--map("n", "<leader>dui", "<cmd>lua require'dapui'.toggle()<CR>", { desc = "Dap Ui Toggle", noremap = true })
map("n", "<leader>do", "<cmd> DapStepOut <CR>", { desc = "Step Out" })
map("n", "<leader>dO", "<cmd> DapStepOver <CR>", { desc = "Step Over" })
map("n", "<leader>dI", "<cmd> DapStepInto <CR>", { desc = "Step Into" })
map("n", "<leader>dp", function()
  require("dap").pause()
end, { desc = "Pause" })
map("n", "<leader>dt", "<cmd> DapTerminate <CR>", { desc = "Terminate" })
map("n", "<leader>dus", function()
  local widgets = require "dap.ui.widgets"
  local sidebar = widgets.sidebar(widgets.scopes)
  sidebar.open()
end, { desc = "Open debugging sidebar" })
map("n", "<leader>dc", "<cmd> DapContinue <CR>", { desc = "Start or continue the debugger" })
map(
  "n",
  "<leader>dr",
  "<cmd>lua require('dapui').open({reset = true }) <CR>",
  { desc = "Reset debugger ui", noremap = true }
)

-- DAP Go keymappings
map("n", "<leader>dgt", function()
  require("dap-go").debug_test()
end, { desc = "Debug go test" })
map("n", "<leader>dgl", function()
  require("dap-go").debug_last()
end, { desc = "Debug last go test" })

-- Gopher keymappings
map("n", "<leader>gsj", "<cmd> GoTagAdd json <CR>", { desc = "Add json struct tags" })
map("n", "<leader>gsy", "<cmd> GoTagAdd yaml <CR>", { desc = "Add yaml struct tags" })
map("n", "<leader>ge", "<cmd> GoIfErr <CR>", { desc = "Add if error boilerplate" })

-- DAP Python keymappings
map("n", "<leader>dpr", function()
  require("dap-python").test_method()
end, { desc = "Test Python method" })

-- trouble keymappings
map("n", "<leader>oe", function()
  require("trouble").toggle()
end)
map("n", "<leader>ow", function()
  require("trouble").toggle "workspace_diagnostics"
end)
map("n", "<leader>od", function()
  require("trouble").toggle "document_diagnostics"
end)
map("n", "<leader>qf", function()
  require("trouble").toggle "quickfix"
end)
map("n", "<leader>ll", function()
  require("trouble").toggle "loclist"
end)
map("n", "gR", function()
  require("trouble").toggle "lsp_references"
end)

map("n", "<leader>tc", function()
  if vim.bo.filetype == "java" then
    require("jdtls").test_class()
  end
end, { desc = "Run Java test class" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
