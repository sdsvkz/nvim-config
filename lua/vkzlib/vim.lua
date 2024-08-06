-- Wrapper for vim.api.nvim_create_augroup
-- By default, sep is underscore and opts is { clear = true }
---@param prefix string
---@param name string
---@param sep? string
---@param opts? vim.api.keyset.create_augroup
---@return integer
local function augroup(prefix, name, sep, opts)
  return vim.api.nvim_create_augroup(prefix .. (sep or "_") .. name, opts or { clear = true })
end

return {
  augroup = augroup,
}
