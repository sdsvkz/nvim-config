local SYSTEM_LIST = {
  WINDOWS = "Windows",
  MACOS = "MacOS",
  LINUX = "Linux"
}

local LSP_SERVER_CONFIG_TABLE = require("config.lspservers")

return {
  -- Preferences
  CURRENT_SYSTEM = SYSTEM_LIST.WINDOWS,
  USE_MASON = true,

  -- Appearence
  theme = "catppuccin",
  main_menu = "theta_modified",

  -- Misc
  SYSTEM_LIST = SYSTEM_LIST,
  LSP_SERVER_CONFIG_TABLE = LSP_SERVER_CONFIG_TABLE,
}
