local merge_plugin_opts = require("profiles.utils").merge_plugin_opts

---@module "nvim-ts-autotag"

---@type nvim-ts-autotag.PluginSetup
local opts = {
  opts = {
    enable_close = true,
    enable_rename = true,
    enable_close_on_slash = true,
  },
}

return {
  'windwp/nvim-ts-autotag',
  event = "InsertEnter",
  opts = merge_plugin_opts(Vkz.vkzlib.io.lua.get_caller_module_path(), opts),
}
