-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "catppuccin",

  hl_override = {
    Comment = { italic = true, fg = "#999999" },
    ["@comment"] = { italic = true, link = "Comment" },
  },
}

return M
