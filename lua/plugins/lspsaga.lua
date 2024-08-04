return {
  'nvimdev/lspsaga.nvim',
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
      "<A-CR>", mode = "n",
      "<CMD>Lspsaga code_action<CR>"
    },
    {
      "<LEADER>gd", mode = "n",
      "<CMD>Lspsaga goto_definition<CR>"
    },
    {
      "<LEADER>pd", mode = "n",
      "<CMD>Lspsaga peek_definition<CR>"
    },
    {
      "<LEADER>gt", mode = "n",
      "<CMD>Lspsaga goto_type_definition<CR>"
    },
    {
      "<LEADER>pt", mode = "n",
      "<CMD>Lspsaga peek_type_definition<CR>"
    },
  },
  dependencies = {
    'nvim-treesitter/nvim-treesitter', -- optional
    'nvim-tree/nvim-web-devicons',     -- optional
  }
}
