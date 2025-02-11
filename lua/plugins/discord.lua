local profile = require("profiles")

if profile.preference.enable_discord_rich_presence then
  return {
    'vyfor/cord.nvim',
    build = ':Cord update',
    opts = {
      editor = {
        tooltip = "The most beautiful clusterfuck in the world"
      }
    },
  }
else
  return {}
end

