---@module "rainbow-delimiters"

return {
  "HiPhish/rainbow-delimiters.nvim",
  init = function ()
    vim.g.rainbow_delimiters = vim.g.rainbow_delimiters or {}
  end
}
