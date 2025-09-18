---@module "lazy"
---@module "conform"
---@module "lint"
---@module "dap"

local vkzlib = Vkz.vkzlib
local log = Vkz.log
local LazyValue = vkzlib.Data.LazyValue
local vassert = vkzlib.core.assert
local to_string = vkzlib.core.to_string
local deep_copy = vkzlib.core.deep_copy
local concat = vkzlib.Data.list.concat
local deep_merge = vkzlib.Data.table.deep_merge
local join = vkzlib.Data.str.join
local fileIO = vkzlib.io.file
local is_module_exists = vkzlib.io.lua.is_module_exists
local first_not_nil = vkzlib.core.first_not_nil
local let = vkzlib.core.let

local utils = {}

---@param PROFILE profiles.Profile
---@param MODULE_NAME string
---@return profiles.Profile
local function merge_profile(PROFILE, MODULE_NAME)
	---@type profiles.Profile
	local USER_PROFILE = deep_copy(require("profiles." .. MODULE_NAME), true)
	local merged = deep_merge("force", PROFILE, USER_PROFILE)
	merged.name = USER_PROFILE.name or MODULE_NAME
	return merged
end

---Check if language `LANG` is enabled
---@param LANGS table<string | string[], profiles.Profile.Languages.Language> Language settings from `Profile`
---@param LANG string
---@return boolean
local function is_language_support_enabled(LANGS, LANG)
	for LANG_NAMES, LANG_CONFIG in pairs(LANGS) do
		if type(LANG_NAMES) == "string" then
			if LANG_NAMES == LANG and LANG_CONFIG.enable == true then
				return true
			end
		else
			for _, LANG_NAME in ipairs(LANG_NAMES) do
				if LANG_NAME == LANG and LANG_CONFIG.enable == true then
					return true
				end
			end
		end
	end
	return false
end

---Retrieve required tools from profile
---@param LANGUAGES profiles.Profile.Languages
---@return { formatters: table<string, profiles.Profile.Languages.Tools.Formatters>, linters: table<string, profiles.Profile.Languages.Tools.Linters>, ls: profiles.Profile.Languages.Tools.LanguageServers, dap: config.dap.Config }
local function get_language_tools(LANGUAGES)
	---@type table<string, profiles.Profile.Languages.Tools.Formatters>
	local formatters = {}
	---@type table<string, profiles.Profile.Languages.Tools.Linters>
	local linters = {}
	---@type profiles.Profile.Languages.Tools.LanguageServers
	local ls = {}
	---@type config.dap.Config
	local dap = {
		adapters = {},
		configurations = {},
	}

	---@type table<string, profiles.Profile.Languages.Language>
	local supported = {}
	-- Flatten languages with multiple name
	for LANG_NAME, LANG_CONFIG in pairs(LANGUAGES.supported) do
		---@cast LANG_NAME string | string[]
		---@cast LANG_CONFIG profiles.Profile.Languages.Language
		if type(LANG_NAME) == "string" then
			-- Leave it untouched
			supported[LANG_NAME] = LANG_CONFIG
		else
			-- Map every filetype to the same language
			for _, V in ipairs(LANG_NAME) do
				supported[V] = LANG_CONFIG
			end
		end
	end
	log.t(to_string(supported))

	-- Merge tools of each languages
	for LANG_NAME, LANG_CONFIG in pairs(LANGUAGES.custom) do
		-- This way make any language with enable flag set to `false`
		-- not be included in the final toolset.
		-- Just like they are "disabled"
		if not LANG_CONFIG.enable then
			goto continue
		end

		---Process to extract tools for `FT`, from `LANG_CONFIG`
		---@param FT string filetype
		---@param OVERRIDE profiles.Profile.Languages.Tools? Toolset to extract
		---@param DEFAULT profiles.Profile.Languages.Tools? Toolset to use if corresponding tools not exists
		local function extract(FT, OVERRIDE, DEFAULT)
			assert(type(FT) == "string", "Extracting tools for invalid filetype")

			-- Set formatters for filetype
			formatters[FT] = first_not_nil(OVERRIDE and OVERRIDE.formatters, DEFAULT and DEFAULT.formatters)
				or formatters[FT]

			-- Set linters for filetype
			linters[FT] = first_not_nil(OVERRIDE and OVERRIDE.linters, DEFAULT and DEFAULT.linters) or linters[FT]

			-- Merge language servers
			if OVERRIDE and OVERRIDE.ls then
				ls = deep_merge("force", ls, OVERRIDE.ls)
			elseif DEFAULT and DEFAULT.ls then
				ls = deep_merge("force", ls, DEFAULT.ls)
			end

			-- DAP

			-- Merge adapters

			local OVERRIDE_DAP_ADAPTERS = OVERRIDE and OVERRIDE.dap and OVERRIDE.dap.adapters
			local DEFAULT_DAP_ADAPTERS = DEFAULT and DEFAULT.dap and DEFAULT.dap.adapters

			if OVERRIDE_DAP_ADAPTERS then
				dap.adapters = deep_merge("force", dap.adapters, OVERRIDE_DAP_ADAPTERS)
			elseif DEFAULT_DAP_ADAPTERS then
				dap.adapters = deep_merge("force", dap.adapters, DEFAULT_DAP_ADAPTERS)
			end

			-- Merge configurations

			local OVERRIDE_DAP_CONFIGS = OVERRIDE and OVERRIDE.dap and OVERRIDE.dap.configurations
			local DEFAULT_DAP_CONFIGS = DEFAULT and DEFAULT.dap and DEFAULT.dap.configurations

			---@param CONFIGS profiles.Profile.Languages.Tools.Dap.Configurations
			local function merge_dap_configurations(CONFIGS)
				for FILETYPE, CONFIG in pairs(CONFIGS) do
					local function merge(it)
						return it and CONFIG and concat(it, CONFIG)
					end
					-- Extract configurations for filetypes of the language
					if FILETYPE == 1 then
						dap.configurations[FT] = let(dap.configurations[FT], merge)
					elseif type(FILETYPE) == "string" then
						dap.configurations[FILETYPE] = let(dap.configurations[FILETYPE], merge)
					else
						error("Invalid filetype for dap configuration: " .. to_string(FILETYPE))
					end
				end
			end

			if OVERRIDE_DAP_CONFIGS then
				merge_dap_configurations(OVERRIDE_DAP_CONFIGS)
			elseif DEFAULT_DAP_CONFIGS then
				merge_dap_configurations(DEFAULT_DAP_CONFIGS)
			end
		end

		-- Extracted filetypes
		local FILETYPES = LANG_CONFIG.filetypes
		if not FILETYPES then
			if type(LANG_NAME) == "string" then
				FILETYPES = { LANG_NAME }
			else
				FILETYPES = LANG_NAME
			end
		end

		for _, FILETYPE in ipairs(FILETYPES) do
			extract(FILETYPE, LANG_CONFIG and LANG_CONFIG.tools, supported[FILETYPE] and supported[FILETYPE].tools)
		end

		::continue::
	end

	return {
		formatters = formatters,
		linters = linters,
		ls = ls,
		dap = dap,
	}
end

---@param spec (string | LazyPluginSpec)?
---@param colorscheme string
---@param theme_config (fun(plugin: table, opts: table, spec: LazyPlugin) | true)?
---@return ((fun(main: string): fun(self: LazyPlugin, opts: table)) | true)?
local function generate_config(spec, colorscheme, theme_config)
	if theme_config == true or theme_config == nil then
		return theme_config
	elseif type(spec) ~= "string" then
		return nil
	end
	return function(main)
		return function(self, opts)
			-- This prevent failing from loading not existing module
			local plugin = require(main)
			theme_config(plugin, opts, self)
			vim.cmd.colorscheme(colorscheme)
		end
	end
end

---Generate complete profile table
---@param PROFILE profiles.Profile
---@return profiles.Profile
local function preprocess_profile(PROFILE)
	local profile = deep_copy(PROFILE, true)
	if profile.appearence.theme.config == nil then
		profile.appearence.theme.config = generate_config(
			profile.appearence.theme.plugin,
			profile.appearence.theme.colorscheme,
			profile.appearence.theme.theme_config
		)
	end

	local TOOLS = get_language_tools(profile.languages)

	profile.languages.formatters = TOOLS.formatters
	profile.languages.linters = TOOLS.linters
	profile.languages.ls = TOOLS.ls
	profile.languages.dap = TOOLS.dap
	profile.utils = utils
	return profile
end

---Extract server name and corresponding config
---@param LS profiles.Profile.Languages.Tools.LanguageServers
---@return table<string, config.lsp.Handler.Config>
local function extract_lspconfigs(LS)
	local name_config_table = {}

	for k, v in pairs(LS) do
		local server_name = k
		local config = v

		if type(k) == "table" then
			server_name = k[1]
		else
			assert(type(k) == "string")
		end

		if type(v) == "table" then
			-- manual_setup make no difference if not using mason
			config = v.config
		else
			assert(type(v) == "boolean" or type(v) == "function")
		end

		name_config_table[server_name] = config
	end

	return name_config_table
end

---Extract Lsp configurations for `config.lsp`
---@param LS profiles.Profile.Languages.Tools.LanguageServers
---@return config.lsp.LspConfig
local function extract_mason_lspconfigs(LS)
	---@type config.lsp.LspConfig
	local res = {
		ensure_installed = {},
		handle_by_mason = {},
		manual_setup = {},
	}
	for server_config, handler in pairs(LS) do
		local server_name = server_config
		if type(server_config) == "table" then
			-- Extract server_name from `config.mason.InstallConfig`
			server_name = server_config[1]
		end
		assert(type(server_name) == "string")

		if type(handler) == "table" then
			-- Put manual ones into `manual_setup` instead of `ensure_installed`
			res.manual_setup[server_name] = handler.config
		else
			if not server_config.no_mason then
				-- Put it into `ensure_installed`, except the one with `no_mason` set
				table.insert(res.ensure_installed, server_config)
			end
			if handler ~= false then
				-- Skip `false` for installing only
				res.handle_by_mason[server_name] = handler
			end
		end
	end

	return res
end

---Extract required linters for `config.lint`
---@param LINTERS table<string, profiles.Profile.Languages.Tools.Linters>
---@return config.lint.LinterConfig
local function extract_required_linters(LINTERS)
	---@type config.lint.LinterConfig
	local res = {
		ensure_installed = {},
		linters = {},
		linters_by_ft = {},
	}

	local linters_by_ft = deep_copy(LINTERS, true)

	for ft, linters_of_ft in pairs(LINTERS) do
		for index, linter in ipairs(linters_of_ft) do
			if type(linter) == "table" then
				local name = linter[1]
				local opts = linter.opts
				local errmsg = LazyValue:new(function()
					return "Invalid LinterSpec: " .. to_string(linter)
				end)
				vassert(type(name) == "string", errmsg)
				if type(opts) == "function" then
					-- Register or override linter
					res.linters[name] = opts
				end
				-- Extract linter name
				linters_by_ft[ft][index] = name
				if not linter.no_mason then
					---Put it into `ensure_installed` if `no_mason` is not set
					---@type MasonInstallConfig
					local config = {
						name,
						auto_update = linter.auto_update,
						version = linter.version,
						condition = linter.condition,
					}
					table.insert(res.ensure_installed, config)
				end
			elseif type(linter) == "string" then
				linters_by_ft[ft][index] = linter
				table.insert(res.ensure_installed, linter)
			else
				log.w("Invalid linter: " .. to_string(linter))
			end
		end
	end

	--- Process above should ensure all `LinterSpec`s have been replaced by linter's name
	res.linters_by_ft = linters_by_ft

	log.t("Extracted linter config: " .. to_string(res))

	return res
end

---Scan for profile
---@return string[]
local function scan_profile()
	---@type string[]
	local found = {}

	for _, FILE_NAME in
		---@diagnostic disable-next-line: param-type-mismatch
		ipairs(vim.fn.readdir(join({ vim.fn.stdpath("config"), "lua", "profiles" }, "/"), [[ v:val =~ '\.lua$' ]]))
	do
		---@cast FILE_NAME string
		if
			FILE_NAME ~= "init.lua"
			and FILE_NAME ~= "options.lua"
			and FILE_NAME ~= "default.lua"
			and FILE_NAME ~= "utils.lua"
		then
			local MODULE_NAME = FILE_NAME:sub(1, #FILE_NAME - 4)
			table.insert(found, MODULE_NAME)
		end
	end

	return found
end

local function create_file(NAME)
	local handle = {}

	---Write `CONTENT` to file
	---On success, `errmsg == nil`
	---@param CONTENT string
	---@return string? errmsg
	function handle:write(CONTENT)
		return fileIO.write_file(Vkz.storage.path .. NAME, CONTENT)
	end

	---Read content from file
	---On success, `errmsg == nil`
	---@return { content: string?, errmsg: string? }
	function handle:read()
		return fileIO.read_file(Vkz.storage.path .. NAME)
	end

	return handle
end

---@type profiles.Profile.Default.Name
local DEFAULT_PROFILE_NAME = "Default"

local profile_name_handle = create_file("profile.used")

---Open a menu for user to choose profile
---@param PROFILE_NAMES string[]
---@param on_select fun(PROFILE_NAME: string)?
local function open_profile_menu(PROFILE_NAMES, on_select)
	table.insert(PROFILE_NAMES, 1, DEFAULT_PROFILE_NAME)

	local buf = vim.api.nvim_create_buf(false, true)
	local PROFILE_COUNT = #PROFILE_NAMES

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, PROFILE_NAMES)

	local WIDTH = 30

	---@type vim.api.keyset.win_config
	local opts = {
		border = "rounded",
		style = "minimal",
		relative = "editor",
		width = WIDTH,
		height = PROFILE_COUNT,
		row = math.floor((vim.o.lines - PROFILE_COUNT) / 2),
		col = math.floor((vim.o.columns - WIDTH) / 2),
	}

	local win_id = vim.api.nvim_open_win(buf, true, opts)

	local function close()
		if win_id and vim.api.nvim_win_is_valid(win_id) then
			vim.api.nvim_win_close(win_id, true)
		end
	end

	local key_opts = {
		nowait = true,
		noremap = true,
		silent = true,
	}

	---@diagnostic disable-next-line: param-type-mismatch
	vim.api.nvim_buf_set_keymap(buf, "n", "<esc>", function()
		close()
	end, key_opts)

	---@diagnostic disable-next-line: param-type-mismatch
	vim.api.nvim_buf_set_keymap(buf, "n", "q", function()
		close()
	end, key_opts)

	---@diagnostic disable-next-line: param-type-mismatch
	vim.api.nvim_buf_set_keymap(buf, "n", "<cr>", function()
		local PROFILE_NAME = vim.api.nvim_get_current_line()
		close()
		vim.schedule(function()
			log.t("Select: " .. to_string(PROFILE_NAME))
			local errmsg = profile_name_handle:write(PROFILE_NAME)
			if errmsg ~= nil then
				log.e("Failed to write profile name: " .. errmsg)
			end
			log.w("Restart Neovim to take effect", vim.log.levels.WARN)
			if on_select ~= nil then
				on_select(PROFILE_NAME)
			end
		end)
	end, key_opts)
end

---Merge opts for current plugin module (Caller of this function)
---Throw error on exception or failure
---@param path string
---@param opts table | fun(self: LazyPluginSpec, o: table): table? Default opts
---@param extras table?
---@return table | fun(self: LazyPluginSpec, o: table): table? merged
local function merge_plugin_opts(path, opts, extras)
	log.t("Merging plugin for " .. path .. "\nopts: " .. to_string(opts) .. "\nextras: " .. to_string(extras))
	if type(opts) ~= "function" and type(opts) ~= "table" then
		error("Cannot merge opts for module: Invalid default opts")
	end
	local profile = require("profiles")
	local regex = "[/\\](plugins[/\\].-[^/\\]+)%.lua$"
	---@type string
	local matched = path:match(regex)
	vassert(
		matched ~= nil,
		LazyValue:new(function()
			return "Cannot merge opts for module: Not a plugin: " .. path
		end)
	)
	---@cast matched string
	local plugin_module_path = matched:gsub("[/\\]", ".")
	vassert(
		is_module_exists(plugin_module_path),
		LazyValue:new(function()
			return "Cannot merge opts for module: Plugin not loaded/loading: " .. plugin_module_path .. "\nIn: " .. path
		end)
	)
	local plugin_name = plugin_module_path:match(".*%.(.*)$")
	local override = profile.preference.plugin_opts[plugin_name]
	log.t("override: " .. to_string(override))
	if type(opts) == "table" then
		if type(override) == "table" then
			local res = deep_merge("force", opts, override)
			log.t("opts merged for " .. plugin_name .. ": " .. to_string(res))
			return res
		elseif type(override) == "function" then
			return function(self, o)
				local new_opts = deep_merge("force", o, opts)
				local res = override(self, new_opts, extras) or new_opts
				log.t("opts merged for " .. plugin_name .. ": " .. to_string(res))
				return res
			end
		else
			return opts
		end
	elseif type(opts) == "function" then
		if type(override) == "table" then
			return function(self, o)
				local new_opts = opts(self, o) or o
				local res = deep_merge("force", new_opts, override)
				log.t("opts merged for " .. plugin_name .. ": " .. to_string(res))
				return res
			end
		elseif type(override) == "function" then
			return function(self, o)
				local new_opts = opts(self, o) or o
				local res = override(self, new_opts, extras) or new_opts
				log.t("opts merged for " .. plugin_name .. ": " .. to_string(res))
				return res
			end
		else
			return opts
		end
	else
		error("Cannot merge opts for module: Invalid default opts")
	end
end

utils.merge_profile = merge_profile
utils.is_ft_support_enabled = is_language_support_enabled
utils.generate_config = generate_config
utils.get_language_tools = get_language_tools
utils.preprocess_profile = preprocess_profile
utils.extract_lspconfigs = extract_lspconfigs
utils.extract_mason_lspconfig = extract_mason_lspconfigs
utils.extract_required_linters = extract_required_linters
utils.scan_profile = scan_profile
utils.create_file = create_file
utils.DEFAULT_PROFILE_NAME = DEFAULT_PROFILE_NAME
utils.profile_name_handle = profile_name_handle
utils.open_profile_menu = open_profile_menu
utils.merge_plugin_opts = merge_plugin_opts

return utils
