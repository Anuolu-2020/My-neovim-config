-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

---@class ChadrcConfig
local M = {}

M.base46 = {
  theme = "catppuccin",

  hl_override = {
    Comment = { italic = true, fg = "#999999" },
    LineNr = { fg = "baby_pink" },
    ["@comment"] = { italic = true, link = "Comment" },
  },
}

return M
