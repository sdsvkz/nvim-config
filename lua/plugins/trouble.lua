local Groups = require("config.key_groups").Groups

return {
  "folke/trouble.nvim",
  opts = {}, -- for default options, refer to the configuration section for custom setup.
  cmd = "Trouble",
  keys = {
    {
      Groups.Trouble.lhs .. "x",
      "<cmd>Trouble diagnostics toggle focus=true<cr>",
      desc = "Diagnostics",
    },
    {
      Groups.Trouble.lhs .. "X",
      "<cmd>Trouble diagnostics toggle focus=true filter.buf=0<cr>",
      desc = "Buffer Diagnostics",
    },
    {
      Groups.Trouble.lhs .. "s",
      "<cmd>Trouble symbols toggle focus=true<cr>",
      desc = "Symbols",
    },
    {
      Groups.Trouble.lhs .. "l",
      "<cmd>Trouble lsp toggle focus=true win.position=right<cr>",
      desc = "LSP Definitions / references / ...",
    },
    {
      Groups.Trouble.lhs .. "L",
      "<cmd>Trouble loclist toggle focus=true<cr>",
      desc = "Location List",
    },
    {
      Groups.Trouble.lhs .. "Q",
      "<cmd>Trouble qflist toggle focus=true<cr>",
      desc = "Quickfix List",
    },
  },
}
