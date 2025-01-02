return {
  'goolord/alpha-nvim',
  dependencies = {
    require("plugins.libs.web_devicons"),
    require("plugins.libs.plenary"),
  },
  keys = {
    {
      "<LEADER>gh", mode = "n",
      "<CMD>Alpha<CR>",
      desc = "Go to home page (Alpha)"
    },
  }
}
