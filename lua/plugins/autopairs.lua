local merge_plugin_opts = require("profiles.utils").merge_plugin_opts

local opts = {}

return {
  'windwp/nvim-autopairs',
  event = "InsertEnter",
  opts = merge_plugin_opts(Vkz.vkzlib.io.lua.get_caller_module_path(), opts),
  -- use opts = {} for passing setup options
  -- this is equivalent to setup({}) function
}
