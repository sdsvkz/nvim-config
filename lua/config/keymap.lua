local wk = require("which-key")

wk.add {
  { "<LEADER>,", group = "Setting" }
}

vim.keymap.set("n", "<LEADER>,l", "<CMD>Lazy<CR>", { desc = "Lazy home" })
vim.keymap.set("n", "<LEADER>F", vim.lsp.buf.format, { desc = "LSP: Format buffer" })
