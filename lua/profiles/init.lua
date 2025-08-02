local vkzlib = Vkz.vkzlib
local log = Vkz.log

local profile = vkzlib.core.deep_copy(require("profiles.default"), true)
local utils = require("profiles.utils")

-- Scan for profile
local profiles_found = {}

for _, FILE_NAME in ipairs(vim.fn.readdir(vkzlib.data.str.join({ vim.fn.stdpath("config"), "lua", "profiles"}, "/"), [[ v:val =~ '\.lua$' ]])) do
  if FILE_NAME ~= "init.lua" and FILE_NAME ~= "options.lua" and FILE_NAME ~= "default.lua" and FILE_NAME ~= "utils.lua" then
    local MODULE_NAME = FILE_NAME:sub(1, #FILE_NAME - 4)
    table.insert(profiles_found, MODULE_NAME)
  end
end

log.t(vkzlib.core.to_string(profiles_found))

if #profiles_found == 1 then
  profile = utils.merge_profile(profile, profiles_found[1])
  -- TODO: Save the used profile
  
end
-- TODO: Load saved profile if exists

return utils.preprocess_profile(profile)
