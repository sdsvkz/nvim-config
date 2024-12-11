-- Scan for profile

local profile = require("profiles.default")

for _, FILE_NAME in ipairs(vim.fn.readdir(vim.fn.stdpath("config") .. "/lua/profiles", [[ v:val =~ '\.lua$' ]])) do
  if FILE_NAME ~= "init.lua" and FILE_NAME ~= "options.lua" and FILE_NAME ~= "default.lua" then
    local PROFILE_NAME = FILE_NAME:sub(1, #FILE_NAME - 4)
    print("Profile: " .. PROFILE_NAME)
    local USER_PROFILE = require("profiles." .. PROFILE_NAME)
    profile = vim.tbl_deep_extend("force", profile, USER_PROFILE)
    break
  end
end

return profile
