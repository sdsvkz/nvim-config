local profile = require("profiles")
local keymap = require("config.keymap")

if profile.utils.is_ft_support_enabled(profile.languages.custom, "c") then
	if profile.utils.is_ft_support_enabled(profile.languages.custom, "cmake") then
		keymap.set_cmake_keymap()
	end
end
