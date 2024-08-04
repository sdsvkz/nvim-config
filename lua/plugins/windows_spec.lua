local options = require("config.options")

if options.CURRENT_SYSTEM == options.SYSTEM_LIST.WINDOWS then
  return {
    require("plugins.windows.im_select")
  }
else
  return {}
end
