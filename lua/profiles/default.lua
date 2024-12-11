--[[
--
-- !!! Don't modify this
-- Create you own profile, name don't matter, e.g. sdsvkz.lua
-- Return table with overrided options
-- Your profile will be merged with default profile
--
-- !!! You should only put one profile under this folder
-- If you want to disable other profile, you can change extension to others
-- e.g. sdsvkz.lua.disabled
--
--]]

return {
  -- Preferences

  ---Operating system used
  ---Used for platform-specific features
  ---@type Profiles.Options.System
  ---@diagnostic disable-next-line: undefined-field
  CURRENT_SYSTEM = vim.uv.os_uname().sysname,

  ---If `true` use mason to install tools, then configure language servers with mason-lspconfig
  ---Otherwise, configure all language servers with lspconfig
  ---@type boolean
  USE_MASON = true,

  -- Appearence

  ---To get list of available themes
  ---Run `:lua for _, theme in ipairs(vim.fn.getcompletion("", "color")) do print(theme) end`
  ---@type string
  THEME = "catppuccin",

  ---Put startup menus into "lua/config/menu"
  ---Choose here using file name without extension
  ---@type string
  MENU = "theta_modified",
}
