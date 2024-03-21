local cmp = require "cmp"

local options = {
mapping = {
  ['<Tab>'] = cmp.mapping(function(fallback)
  if cmp.visible() then
    cmp.select_next_item()
  elseif require('luasnip').expand_or_jumpable() then
    vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
  elseif vim.b._copilot_suggestion ~= nil then
    vim.fn.feedkeys(vim.api.nvim_replace_termcodes(vim.fn['copilot#Accept'](), true, true, true), '')
  else
    fallback()
  end
end, {
  'i',
  's',
}),
}
}

return options
