local profile = require("profiles")

---@type LazyPluginSpec
return {
  "mfussenegger/nvim-dap",
  dependencies = {
    {
      "williamboman/mason.nvim",
      enabled = profile.preference.use_mason == true,
    },
  },
}
