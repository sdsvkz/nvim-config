local profile = require("profiles")

if profile.preference.use_mason then
  return {
    {
      "williamboman/mason.nvim",
      opts = {},
      keys = {
        {
          "<LEADER>,m", mode = "n",
          "<CMD>Mason<CR>",
          desc = "Mason home"
        },
      },
    },
    require("plugins.mason.dap"),
    require("plugins.mason.lspconfig"),
    require("plugins.mason.tool_installer"),
  }
else
  return {}
end
