return Vkzlib.core.conditional(
  require("config.options").USE_MASON,
  {
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
    require("plugins.mason.lspconfig"),
    require("plugins.mason.tool_installer"),
  },
  {}
)
