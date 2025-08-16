---@module "conform"

local vkzlib = Vkz.vkzlib
local log = Vkz.log
local deep_copy = vkzlib.core.deep_copy
local deep_merge = vkzlib.data.table.deep_merge
local fileIO = vkzlib.io.file

local utils = {}

---@param PROFILE profiles.Profile
---@param MODULE_NAME string
---@return profiles.Profile
local function merge_profile(PROFILE, MODULE_NAME)
	---@type profiles.Profile
	local USER_PROFILE = vkzlib.core.deep_copy(require("profiles." .. MODULE_NAME), true)
	local merged = deep_merge("force", PROFILE, USER_PROFILE)
	merged.name = USER_PROFILE.name or MODULE_NAME
	return merged
end

---@param LANGS table<string | string[], profiles.Profile.Languages.Language>
---@param FT string
---@return boolean
local function is_ft_support_enabled(LANGS, FT)
	for FILETYPES, LANG in pairs(LANGS) do
		if type(FILETYPES) == "string" then
			if FILETYPES == FT and LANG.enable == true then
				return true
			end
		else
			for _, FILETYPE in ipairs(FILETYPES) do
				if FILETYPE == FT and LANG.enable == true then
					return true
				end
			end
		end
	end
	return false
end

---Retrieve required tools from profile
---@param LANGUAGES profiles.Profile.Languages
---@return { formatters: table<string, conform.FiletypeFormatter>, linters: table<string, (string | config.lint.LinterSpec)[]>, ls: { [config.lsp.Server.MasonConfig]: config.lsp.Handler } }
local function get_language_tools(LANGUAGES)
	-- TODO: Extract dap as soon as nvim-dap is added

	---@type table<string, conform.FiletypeFormatter>
	local formatters = {}
	---@type table<string, (string | config.lint.LinterSpec)[]>
	local linters = {}
	---@type { [config.lsp.Server.MasonConfig]: config.lsp.Handler }
	local ls = {}

	---@type table<string, profiles.Profile.Languages.Language>
	local supported = {}
	for FT, LANG in pairs(LANGUAGES.supported) do
		---@cast FT string | string[]
		---@cast LANG profiles.Profile.Languages.Language
		if type(FT) == "string" then
			supported[FT] = LANG
		else
			for _, V in ipairs(FT) do
				supported[V] = LANG
			end
		end
	end
	log.t(vkzlib.core.to_string(supported))

	-- TODO: Make enable by default possible
	-- All Languages are disabled by default
	-- So see if any of them in `custom` has been enabled
	for FT, LANG in pairs(LANGUAGES.custom) do
		if LANG.enable then
			---Process to extract tools for `filetype`, from `lang`
			---@param filetype string
			local function extract(filetype)
				assert(type(filetype) == "string", "Extracting tools for invalid filetype")
				-- Default toolset if corresponding tools not exists
				local DEFAULT = supported[filetype]
				if type(DEFAULT) == "table" then
					local is_tools_exists = type(LANG.tools) == "table"
					formatters[filetype] = is_tools_exists and LANG.tools.formatters
						or vkzlib.core.deep_copy(DEFAULT.tools.formatters, true)
					linters[filetype] = is_tools_exists and LANG.tools.linters
						or vkzlib.core.deep_copy(DEFAULT.tools.linters, true)
					ls = deep_merge("force", ls, is_tools_exists and LANG.tools.ls or DEFAULT.tools.ls or {})
				else
					formatters[filetype] = LANG.tools.formatters
					linters[filetype] = LANG.tools.linters
					ls = deep_merge("force", ls, LANG.tools.ls)
				end
			end

			if type(FT) == "string" then
				extract(FT)
			else
				for _, V in ipairs(FT) do
					extract(V)
				end
			end
		end
	end

	return {
		formatters = formatters,
		linters = linters,
		ls = ls,
	}
end

---@param colorscheme string
---@param theme_config (fun(plugin: table, opts: table, spec: LazyPlugin) | true)?
---@return ((fun(main: string): fun(self: LazyPlugin, opts: table)) | true)?
local function generate_config(colorscheme, theme_config)
	if theme_config == true or theme_config == nil then
		return theme_config
	end
	return function(main)
		return function(self, opts)
			-- This prevent failing from loading not existing module
			local ok, plugin = pcall(require, main)
			if ok then
				theme_config(plugin, opts, self)
				-- This prevent setup code of other themes from changing colorscheme
				vim.cmd.colorscheme(colorscheme)
			end
		end
	end
end

---Generate complete profile table
---@param PROFILE profiles.Profile
---@return profiles.Profile
local function preprocess_profile(PROFILE)
	local profile = deep_copy(PROFILE, true)
	if profile.appearence.theme.config == nil then
		profile.appearence.theme.config =
			generate_config(profile.appearence.theme.colorscheme, profile.appearence.theme.theme_config)
	end

	local TOOLS = get_language_tools(profile.languages)

	profile.languages.formatters = TOOLS.formatters
	profile.languages.linters = TOOLS.linters
	profile.languages.ls = TOOLS.ls
	profile.utils = utils
	return profile
end

---Write the profile name to storage
---@param NAME string
---@return string? errmsg
local function write_profile_name(NAME)
  local errmsg = fileIO.write_file(Vkz.storage.path .. "profile.used", NAME)
  if errmsg ~= nil then
    log.e("Failed to write profile name to storage: " .. vkzlib.core.to_string(errmsg))
  end
  return errmsg
end

---Read the profile name from storage
---@return string?
local function read_profile_name()
  local res = fileIO.read_file(Vkz.storage.path .. "profile.used")
  if res.content ~= nil then
    return res.content
  else
    log.e("Failed to read profile name from storage: " .. (res.errmsg or "Unexpected exception."))
  end
end

utils.merge_profile = merge_profile
utils.is_ft_support_enabled = is_ft_support_enabled
utils.generate_config = generate_config
utils.get_language_tools = get_language_tools
utils.preprocess_profile = preprocess_profile
utils.write_profile_name = write_profile_name
utils.read_profile_name = read_profile_name

return utils
