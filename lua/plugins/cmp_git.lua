local merge_plugin_opts = require("profiles.utils").merge_plugin_opts

local opts = {}

return {
  "petertriho/cmp-git",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = merge_plugin_opts(Vkz.vkzlib.io.lua.get_caller_module_path(), opts),
}
