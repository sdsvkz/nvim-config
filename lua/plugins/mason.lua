if require("config.options").USE_MASON then
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
    require("plugins.mason.lspconfig"),
    require("plugins.mason.tool_installer")
  }
else
  return {}
end
