local Groups = require("config.key_groups").Groups

return {
  "folke/trouble.nvim",
  opts = {}, -- for default options, refer to the configuration section for custom setup.
  cmd = "Trouble",
  keys = {
    {
      Groups.Trouble.lhs .. "x",
      "<cmd>Trouble diagnostics toggle focus=true<cr>",
      desc = "Diagnostics (Trouble)",
    },
    {
      Groups.Trouble.lhs .. "X",
      "<cmd>Trouble diagnostics toggle focus=true filter.buf=0<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
    {
      Groups.Trouble.lhs .. "s",
      "<cmd>Trouble symbols toggle focus=true<cr>",
      desc = "Symbols (Trouble)",
    },
    {
      Groups.Trouble.lhs .. "l",
      "<cmd>Trouble lsp toggle focus=true win.position=right<cr>",
      desc = "LSP Definitions / references / ... (Trouble)",
    },
    {
      Groups.Trouble.lhs .. "L",
      "<cmd>Trouble loclist toggle focus=true<cr>",
      desc = "Location List (Trouble)",
    },
    {
      Groups.Trouble.lhs .. "Q",
      "<cmd>Trouble qflist toggle focus=true<cr>",
      desc = "Quickfix List (Trouble)",
    },
  },
}
