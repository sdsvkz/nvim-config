local profile = require("profiles")

if not profile.preference.use_ai then
	return {}
end

return {
  require("plugins.ai.vector_code"),
  require("plugins.ai.mcphub"),
	require("plugins.ai.codecompanion"),
}
