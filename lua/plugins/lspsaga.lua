local Groups = require("config.key_groups").Groups

return {
  'nvimdev/lspsaga.nvim',
  event = 'LspAttach',
  opts = {
    diagnostic = {
      show_layout = "normal"
    },
    code_action = {
      keys = {
        quit = { "q", "<ESC>" },
        exec = { "<CR>" }
      }
    },
    rename = {
      keys = {
        quit = { "q", "<ESC>" },
        exec = { "<CR>" }
      }
    },
  },
  keys = {
    {
      Groups.Show.lhs .. "ci", mode = "n",
      "<CMD>Lspsaga incoming_calls<CR>",
      desc = "Display incoming call hierarchy"
    },
    {
      Groups.Show.lhs .. "co", mode = "n",
      "<CMD>Lspsaga outgoing_calls<CR>",
      desc = "Display outgoing call hierarchy"
    },
    {
      "[e", mode = "n",
      "<CMD>Lspsaga diagnostic_jump_next<CR>",
      desc = "Previous diagnostic"
    },
    {
      "<A-CR>", mode = "n",
      "<CMD>Lspsaga code_action<CR>",
      desc = "Code action in cursor"
    },
    -- Use `K` (hover.nvim) instead
    -- {
    --   "<LEADER>sd", mode = "n",
    --   "<CMD>Lspsaga hover_doc<CR>",
    --   desc = "Show documentation of hovering"
    -- },
    {
      Groups.Goto.lhs .. "d", mode = "n",
      "<CMD>Lspsaga goto_definition<CR>",
      desc = "Go to definition"
    },
    {
      Groups.Peek.lhs .. "d", mode = "n",
      "<CMD>Lspsaga peek_definition<CR>",
      desc = "Peek definition"
    },
    {
      Groups.Goto.lhs .. "t", mode = "n",
      "<CMD>Lspsaga goto_type_definition<CR>",
      desc = "Go to type definition"
    },
    {
      Groups.Peek.lhs .. "t", mode = "n",
      "<CMD>Lspsaga peek_type_definition<CR>",
      desc = "Peek type definition"
    },
    {
      Groups.Editing.lhs .. "r", mode = "n",
      "<CMD>Lspsaga rename<CR>",
      desc = "Rename"
    },
  },
  dependencies = {
    require("plugins.treesitter"), -- optional
    require("plugins.libs.web_devicons"), -- optional
  }
}
