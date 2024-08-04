if require("config.options").USE_MASON then
  return {
    {
      "williamboman/mason.nvim",
      opts = {}
    },
    require("plugins.mason.lspconfig"),
    require("plugins.mason.tool_installer")
  }
else
  return {}
end
