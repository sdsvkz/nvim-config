local merge_plugin_opts = require("profiles.utils").merge_plugin_opts

---@module "neotest"

---@param self LazyPluginSpec
---@param o neotest.Config
---@return neotest.Config
local function opts(self, o)
  return o
end

---@type LazyPluginSpec
return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
  opts = merge_plugin_opts(Vkz.vkzlib.io.lua.get_caller_module_path(), opts)
}
