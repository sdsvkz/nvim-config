local profile = require("profiles")

local plugins = {}
local LANG_PATH = vim.fn.stdpath("config") .. "/lua/plugins/lang"

for _, lang in ipairs(vim.fn.readdir(LANG_PATH)) do
	---@cast lang string
	if profile.utils.is_ft_support_enabled(profile.languages.custom, lang) then
		---@diagnostic disable-next-line: param-type-mismatch
		for _, FILE_NAME in ipairs(vim.fn.readdir(LANG_PATH .. "/" .. lang, [[ v:val =~ '\.lua$' ]])) do
			---@cast FILE_NAME string
			table.insert(plugins, require("plugins.lang." .. lang .. "." .. FILE_NAME:sub(1, #FILE_NAME - 4)))
		end
	end
end

return plugins
