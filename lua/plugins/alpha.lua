return {
  'goolord/alpha-nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'nvim-lua/plenary.nvim'
  },
  keys = {
    {
      "<LEADER>gh", mode = "n",
      "<CMD>Alpha<CR>",
      desc = "Go to home page (Alpha)"
    },
  }
}
