local profile = require("profiles")
local options = require("profiles.options")

if profile.preference.os == options.System.Windows then
  return {
    require("plugins.windows.im_select")
  }
else
  return {}
end
