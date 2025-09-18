local merge_plugin_opts = require("profiles.utils").merge_plugin_opts

---@module "rustaceanvim"

---@type rustaceanvim.Opts
local opts = {}

---@type LazyPluginSpec
return {
  'mrcjkb/rustaceanvim',
  -- version = '^6', -- Recommended
  lazy = false, -- This plugin is already lazy
  init = function (_)
    vim.g.rustaceanvim = merge_plugin_opts(Vkz.vkzlib.io.lua.get_caller_module_path(), opts)
  end,
}
