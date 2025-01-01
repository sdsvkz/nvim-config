local profile = require("profiles")

if profile.utils.is_ft_support_enabled(profile.languages.custom, "rust") then
  return {
    require("plugins.rust.rustaceanvim"),
  }
else
  return {}
end
