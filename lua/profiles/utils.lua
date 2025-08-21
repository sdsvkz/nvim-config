---@module "conform"
---@module "lint"

local vkzlib = Vkz.vkzlib
local log = Vkz.log
local LazyValue = vkzlib.Data.LazyValue
local core = vkzlib.core
local deep_copy = vkzlib.core.deep_copy
local concat = vkzlib.Data.list.concat
local deep_merge = vkzlib.Data.table.deep_merge
local unpack = vkzlib.Data.list.unpack
local join = vkzlib.Data.str.join
local fileIO = vkzlib.io.file

local utils = {}

utils.toolsConfig = {
	bashls = {
		masonConfig = { "bashls", auto_update = true },
	},
	clangd = {
		masonConfig = { "clangd", auto_update = true },
	},
  ---@type config.lint.LinterSpec
	luacheck = {
		"luacheck",
		auto_update = true,
    -- -- Example on disable auto-installation
    -- condition = function ()
    --   return false
    -- end,
		opts = function(linter)
			---@type lint.Linter
			---@diagnostic disable-next-line: missing-fields
			local properties = {
				args = {
					-- Ignore some warnings, see https://luacheck.readthedocs.io/en/stable/warnings.html
					-- Some of them are duplicated with `luals`, others are annoying
					"--ignore",
					"21*",
					"611",
					"612",
					"631",
					unpack(linter.args),
				},
			}
			return deep_merge("force", linter, properties)
		end,
	},
	lua_ls = {
		masonConfig = { "lua_ls", auto_update = true },
		handler = function()
			vim.lsp.config("lua_ls", {
				on_init = function(client)
					local path = client.workspace_folders[1].name
					---@diagnostic disable-next-line: undefined-field
					if
						---@diagnostic disable-next-line: undefined-field
						vim.uv.fs_stat(path .. "/.luarc.json")
						---@diagnostic disable-next-line: undefined-field
						or vim.uv.fs_stat(path .. "/.luarc.jsonc")
					then
						return
					end

					client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
						runtime = {
							-- Tell the language server which version of Lua you're using
							-- (most likely LuaJIT in the case of Neovim)
							version = "LuaJIT",
						},
						-- Make the server aware of Neovim runtime files
						workspace = {
							checkThirdParty = false,
							library = {
								vim.env.VIMRUNTIME,
								-- Depending on the usage, you might want to add additional paths here.
								-- "${3rd}/luv/library"
								-- "${3rd}/busted/library",
							},
							-- or pull in all of 'runtimepath'.
							-- library = vim.api.nvim_get_runtime_file("", true)
						},
					})
				end,

				settings = {
					Lua = {},
				},
			})
			vim.lsp.enable("lua_ls")
		end,
	},
	jsonls = {
		masonConfig = { "jsonls", auto_update = true },
		handler = function()
			vim.lsp.config("jsonls", {
				settings = {
					json = {
						format = {
							enable = true,
						},
						schemas = concat(require("schemastore").json.schemas({
							extra = {
								{
									description = "Lua language server configuration file",
									fileMatch = { ".luarc.json" },
									name = ".luarc.json",
									url = "https://raw.githubusercontent.com/sumneko/vscode-lua/master/setting/schema.json",
								},
							},
						})),
						validate = { enable = true },
					},
				},
			})
			vim.lsp.enable("jsonls")
		end,
	},
	neocmake = {
		masonConfig = { "neocmake", auto_update = true },
		handler = function()
			vim.lsp.config("neocmake", {
				init_options = {
					-- Annoying
					lint = {
						enable = false,
					},
				},
			})
			vim.lsp.enable("neocmake")
		end,
	},
	powershell_es = {
		masonConfig = { "powershell_es", auto_update = true },
		handler = function()
			vim.lsp.config("powershell_es", {
				bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
				init_options = {
					enableProfileLoading = false,
				},
			})
			vim.lsp.enable("powershell_es")
		end,
	},
	pyright = {
		masonConfig = { "pyright", auto_update = true },
	},
	yamlls = {
		masonConfig = { "yamlls", auto_update = true },
		handler = function()
			vim.lsp.config("yamlls", {
				settings = {
					yaml = {
						format = {
							enable = true,
						},
						validate = true,
						schemas = require("schemastore").yaml.schemas(),
						schemaStore = {
							-- Must disable built-in schemaStore support to use
							-- schemas from SchemaStore.nvim plugin
							enable = false,
							-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
							url = "",
						},
					},
				},
			})
			vim.lsp.enable("yamlls")
		end,
	},
}

---@param PROFILE profiles.Profile
---@param MODULE_NAME string
---@return profiles.Profile
local function merge_profile(PROFILE, MODULE_NAME)
	---@type profiles.Profile
	local USER_PROFILE = core.deep_copy(require("profiles." .. MODULE_NAME), true)
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
---@return { formatters: table<string, profiles.Profile.Languages.Tools.Formatters>, linters: table<string, profiles.Profile.Languages.Tools.Linters>, ls: profiles.Profile.Languages.Tools.LanguageServers }
local function get_language_tools(LANGUAGES)
	-- TODO: Extract dap as soon as nvim-dap is added

	---@type table<string, profiles.Profile.Languages.Tools.Formatters>
	local formatters = {}
	---@type table<string, profiles.Profile.Languages.Tools.Linters>
	local linters = {}
	---@type profiles.Profile.Languages.Tools.LanguageServers
	local ls = {}

	---@type table<string, profiles.Profile.Languages.Language>
	local supported = {}
	-- Flatten languages with multiple filetypes
	for FT, LANG in pairs(LANGUAGES.supported) do
		---@cast FT string | string[]
		---@cast LANG profiles.Profile.Languages.Language
		if type(FT) == "string" then
			-- Leave it untouched
			supported[FT] = LANG
		else
			-- Map every filetype to the same language
			for _, V in ipairs(FT) do
				supported[V] = LANG
			end
		end
	end
	log.t(core.to_string(supported))

	-- Merge tools of each languages
	for FT, LANG in pairs(LANGUAGES.custom) do
		-- This way make any language with enable flag set to `false`
		-- not be included in the final toolset.
		-- Just like they are "disabled"
		if LANG.enable then
			---Process to extract tools for `FILETYPE`, from `LANG`
			---@param FILETYPE string
			local function extract(FILETYPE)
				assert(type(FILETYPE) == "string", "Extracting tools for invalid filetype")
				-- Default toolset if corresponding tools not exists
				local DEFAULT = supported[FILETYPE]
				if type(DEFAULT) == "table" then
					local is_tools_exists = type(LANG.tools) == "table"
					formatters[FILETYPE] = is_tools_exists and LANG.tools.formatters
						or core.deep_copy(DEFAULT.tools.formatters, true)
					linters[FILETYPE] = is_tools_exists and LANG.tools.linters
						or core.deep_copy(DEFAULT.tools.linters, true)
					ls = deep_merge("force", ls, is_tools_exists and LANG.tools.ls or DEFAULT.tools.ls or {})
				else
					formatters[FILETYPE] = LANG.tools.formatters
					linters[FILETYPE] = LANG.tools.linters
					ls = deep_merge("force", ls, LANG.tools.ls)
				end
			end

			if type(FT) == "string" then
				extract(FT)
			else
				-- Merge every filetype in language with multiple filetype
				-- NOTE: Need optimize
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
			-- Put manual ones into manual_setup instead of ensure_installed
			res.manual_setup[server_name] = handler.config
		else
			-- Put all others into ensure_installed
			table.insert(res.ensure_installed, server_config)
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
				---@type MasonInstallConfig
				local config = {
					linter[1],
					auto_update = linter.auto_update,
					condition = linter.condition,
					version = linter.version,
				}
				local opts = linter.opts
				local errmsg = LazyValue:new(function()
					return "Invalid LinterSpec: " .. core.to_string(linter)
				end)
				core.assert(type(config[1]) == "string", errmsg)
				if type(opts) == "function" then
					-- Register or override linter
					res.linters[config[1]] = opts
				end
				-- Extract linter name
				linters_by_ft[ft][index] = config[1]
				table.insert(res.ensure_installed, config)
			elseif type(linter) == "string" then
				linters_by_ft[ft][index] = linter
				table.insert(res.ensure_installed, linter)
			else
				log.w("Invalid linter: " .. core.to_string(linter))
			end
		end
	end

	--- Process above should ensure all `LinterSpec`s have been replaced by linter's name
	res.linters_by_ft = linters_by_ft

	log.t("Extracted linter config: " .. core.to_string(res))

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

---@type profiles.Profile.Default.Name
local DEFAULT_PROFILE_NAME = "Default"

---Write the profile name to storage
---On success, `errmsg == nil`
---@param NAME string
---@return string? errmsg
local function write_profile_name(NAME)
  return fileIO.write_file(Vkz.storage.path .. "profile.used", NAME)
end

---Read the profile name from storage
---On success, `errmsg == nil`
---@return { content: string?, errmsg: string? }
local function read_profile_name()
	return fileIO.read_file(Vkz.storage.path .. "profile.used")
end

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
  vim.api.nvim_buf_set_keymap(buf, "n", "q", function ()
    close()
  end, key_opts)

  ---@diagnostic disable-next-line: param-type-mismatch
  vim.api.nvim_buf_set_keymap(buf, "n", "<cr>", function ()
    local PROFILE_NAME = vim.api.nvim_get_current_line()
    close()
    vim.schedule(function ()
      log.t("Select: " ..  core.to_string(PROFILE_NAME))
      local errmsg = write_profile_name(PROFILE_NAME)
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

utils.merge_profile = merge_profile
utils.is_ft_support_enabled = is_ft_support_enabled
utils.generate_config = generate_config
utils.get_language_tools = get_language_tools
utils.preprocess_profile = preprocess_profile
utils.extract_lspconfigs = extract_lspconfigs
utils.extract_mason_lspconfig = extract_mason_lspconfigs
utils.extract_required_linters = extract_required_linters
utils.scan_profile = scan_profile
utils.DEFAULT_PROFILE_NAME = DEFAULT_PROFILE_NAME
utils.write_profile_name = write_profile_name
utils.read_profile_name = read_profile_name
utils.open_profile_menu = open_profile_menu

return utils
