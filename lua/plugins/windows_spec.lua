local options = require("config.options")

return Vkzlib.core.conditional(
  options.CURRENT_SYSTEM == options.SYSTEM_LIST.WINDOWS,
  {
    require("plugins.windows.im_select")
  },
  {}
)
