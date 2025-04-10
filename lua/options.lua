require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt = "both" -- to enable cursorline

-- DapBreakpoint Ui Icon
vim.fn.sign_define("DapBreakpoint", {
  text = "🔴", -- nerdfonts icon here
  texthl = "DapBreakpoint",
  linehl = "DapBreakpoint",
  numhl = "DapBreakpoint",
})
vim.fn.sign_define("DapStopped", {
  text = "⏹️",
  texthl = "DapBreakpoint",
  linehl = "DapBreakpoint",
  numhl = "DapBreakpoint",
})
