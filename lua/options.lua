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

vim.api.nvim_create_autocmd("BufDelete", {
  callback = function()
    local bufs = vim.t.bufs
    if #bufs == 1 and vim.api.nvim_buf_get_name(bufs[1]) == "" then
      vim.cmd "Nvdash"
    end
  end,
})
