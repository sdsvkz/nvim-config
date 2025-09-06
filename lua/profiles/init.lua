local vkzlib = Vkz.vkzlib
local log = Vkz.log
local core = vkzlib.core
local list = vkzlib.Data.list

local profile = core.deep_copy(require("profiles.default"), true)
local utils = require("profiles.utils")
local DEFAULT_PROFILE_NAME = utils.DEFAULT_PROFILE_NAME

local profiles_found = utils.scan_profile()

log.t(core.to_string(profiles_found))

local profile_count = #profiles_found

local read_res = utils.profile_name_handle:read()

-- Decide profile
if read_res.errmsg ~= nil then
  utils.profile_name_handle:write(DEFAULT_PROFILE_NAME)
elseif profile_count >= 1 then
  ---@type string
  local profile_name = read_res.content
  log.t(core.to_string(profile_name))
  if profile_name ~= nil and profile_name ~= DEFAULT_PROFILE_NAME then
    local profile_index = list.elemIndex(profile_name, profiles_found)
    if profile_index ~= nil then
      profile = utils.merge_profile(profile, profiles_found[profile_index])
    else
      log.e("Profile not exists: " .. core.to_string(profile_name))
      log.e("Switching to default")
      utils.profile_name_handle:write(DEFAULT_PROFILE_NAME)
    end
  end
else
  log.e("Unexpected exception occurred when deciding profile")
end

return utils.preprocess_profile(profile)
