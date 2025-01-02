local profile = require("profiles")

local plugins = {}
local LANG_PATH = vim.fn.stdpath("config") .. "/lua/plugins/lang"

for _, lang in ipairs(vim.fn.readdir(LANG_PATH)) do
  ---@cast lang string
  if profile.utils.is_ft_support_enabled(profile.languages.custom, lang) then
    for _, f in ipairs(vim.fn.readdir(LANG_PATH .. "/" .. lang, [[ v:val =~ '\.lua$' ]])) do
      ---@cast f string
      table.insert(plugins, require("plugins.lang." .. lang .. "." .. f:sub(1, #f - 4)))
    end
  end
end

return plugins
