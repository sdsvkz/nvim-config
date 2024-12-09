-- TODO: Need more documentations

return {
  -- Preferences

  ---@type Profiles.Options.System
  CURRENT_SYSTEM = vim.uv.os_uname().sysname,

  ---@type boolean
  USE_MASON = true,

  -- Appearence

  -- TODO: Enumerate themes
  ---@type string
  THEME = "catppuccin",

  -- TODO: Enumerate menus
  ---@type string
  MENU = "theta_modified",
}
