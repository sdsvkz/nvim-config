local profile = require("profiles")

---@type LazyPluginSpec
return {
  "mfussenegger/nvim-dap",
  config = function ()
    local dap = require("dap")
  end,
}
