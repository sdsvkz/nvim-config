local Groups = require("config.key_groups").Groups

return {
  'goolord/alpha-nvim',
  dependencies = {
    require("plugins.libs.web_devicons"),
    require("plugins.libs.plenary"),
    require("plugins.libs.nui")
  },
  keys = {
    {
      Groups.Goto.lhs .. "h", mode = "n",
      "<CMD>Alpha<CR>",
      desc = "Go to home page (Alpha)"
    },
  }
}
