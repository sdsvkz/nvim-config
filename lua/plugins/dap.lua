local dap = require("config.dap")

---@type LazyPluginSpec
return {
	"mfussenegger/nvim-dap",
	config = function()
    dap.setup(dap.adapters, dap.configurations)
	end,
}
