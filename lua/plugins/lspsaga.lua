return {
  'nvimdev/lspsaga.nvim',
  lazy = false,
  opts = {
    diagnostic = {
      show_layout = "normal"
    },
    code_action = {
      keys = {
        quit = { "q", "<ESC>" },
        exec = { "<CR>" }
      }
    }
  },
  keys = {
    {
      "<LEADER>sci", mode = "n",
      "<CMD>Lspsaga incoming_calls<CR>",
      desc = "Display incoming call hierarchy"
    },
    {
      "<LEADER>sco", mode = "n",
      "<CMD>Lspsaga outgoing_calls<CR>",
      desc = "Display outgoing call hierarchy"
    },
    {
      "<A-CR>", mode = "n",
      "<CMD>Lspsaga code_action<CR>",
      desc = "Code action in cursor"
    },
    {
      "<LEADER>sd", mode = "n",
      "<CMD>Lspsaga hover_doc<CR>",
      desc = "Show documentation of hovering"
    },
    {
      "<LEADER>gd", mode = "n",
      "<CMD>Lspsaga goto_definition<CR>",
      desc = "Go to definition"
    },
    {
      "<LEADER>pd", mode = "n",
      "<CMD>Lspsaga peek_definition<CR>",
      desc = "Peek definition"
    },
    {
      "<LEADER>gt", mode = "n",
      "<CMD>Lspsaga goto_type_definition<CR>",
      desc = "Go to type definition"
    },
    {
      "<LEADER>pt", mode = "n",
      "<CMD>Lspsaga peek_type_definition<CR>",
      desc = "Peek type definition"
    },
    {
      "<S-R>", mode = "n",
      "<CMD>Lspsaga rename<CR>",
      desc = "Rename"
    },
  },
  dependencies = {
    require("plugins.treesitter"), -- optional
    require("plugins.libs.web_devicons"), -- optional
  }
}
