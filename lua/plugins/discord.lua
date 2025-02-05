local profile = require("profiles")

if profile.preference.enable_discord_rich_presence then
  return {
    'vyfor/cord.nvim',
    build = ':Cord update',
    -- opts = {}
  }
else
  return {}
end

