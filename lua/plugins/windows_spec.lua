local options = require("config.options")

local conditional = Vkzlib.core.conditional

return conditional(
  options.CURRENT_SYSTEM == options.SYSTEM_LIST.WINDOWS,
  {
    require("plugins.windows.im_select")
  },
  {}
)
