local profile = require("profiles")

if profile.utils.is_ft_support_enabled(profile.languages.custom, "rust") then
  local bufnr = vim.api.nvim_get_current_buf()
  vim.keymap.set(
    "n",
    "<A-CR>",
    function()
      vim.cmd.RustLsp('codeAction') -- supports rust-analyzer's grouping
      -- or vim.lsp.buf.codeAction() if you don't want grouping.
    end,
    { silent = true, buffer = bufnr }
  )
  vim.keymap.set(
    "n",
    "K", -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
    function()
      vim.cmd.RustLsp({'hover', 'actions'})
    end,
    { silent = true, buffer = bufnr }
  )
end
