-- Generate profile

local profile = Vkzlib.core.deep_copy(require("profiles.default"), true)
local utils = require("profiles.utils")

-- Scan for profile
for _, FILE_NAME in ipairs(vim.fn.readdir(vim.fn.stdpath("config") .. "/lua/profiles", [[ v:val =~ '\.lua$' ]])) do
  if FILE_NAME ~= "init.lua" and FILE_NAME ~= "options.lua" and FILE_NAME ~= "default.lua" then
    local PROFILE_NAME = FILE_NAME:sub(1, #FILE_NAME - 4)
    print("Profile: " .. PROFILE_NAME)
    local USER_PROFILE = Vkzlib.core.deep_copy(require("profiles." .. PROFILE_NAME), true)
    profile = Vkzlib.table.deep_merge("force", profile, USER_PROFILE)
    break
  end
end

local tools = utils.get_language_tools(profile.languages)

profile.languages.formatters = tools.formatters
profile.languages.linters = tools.linters
profile.languages.ls = tools.ls
profile.utils = utils

return profile
