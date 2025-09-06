local Groups = require("config.key_groups").Groups

---@type LazyPluginSpec
return {
  'goolord/alpha-nvim',
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    {
      Groups.Goto.lhs .. "h", mode = "n",
      "<CMD>Alpha<CR>",
      desc = "Go to home page (Alpha)"
    },
  }
}
