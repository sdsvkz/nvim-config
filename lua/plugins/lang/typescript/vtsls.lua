---@type LazyPluginSpec
return {
  "yioneko/nvim-vtsls",
  dependencies = {
    require("plugins.telescope"),
    require("plugins.lspconfig")
  },
  lazy = false,
}
