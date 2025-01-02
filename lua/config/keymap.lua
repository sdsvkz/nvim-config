local wk = require("which-key")
local dapui = require("dapui")

wk.add {
  -- Groups
  { "<LEADER>,", group = "Setting" },
  { "<LEADER>x", group = "UIs" },
  { "<LEADER>s", group = "Show / Send" },
  { "<LEADER>g", group = "Goto / Generate" },
  { "<LEADER>p", group = "Peek" },
  { "<LEADER>d", group = "Debugging" }
}

vim.keymap.set("n", "<LEADER>,l", "<CMD>Lazy<CR>", { desc = "Lazy home" })
vim.keymap.set("n", "<LEADER>F", function() return vim.lsp.buf.format() end, { desc = "LSP: Format buffer" })
vim.keymap.set("n", "<LEADER>xD", function() return dapui.toggle() end, { desc = "Toggle all debugging windows" })
