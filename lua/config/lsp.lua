local vkzlib = Vkz.vkzlib
local Table = vkzlib.data.table

local lspconfig = require("lspconfig")
local profile = require("profiles")
local server_config_table = profile.languages.ls
assert(server_config_table ~= nil, "Profile with invalid language server config")

---Options of Mason package
---@class (exact) MasonConfig
---@field [1] string Package name
---@field version string? Package version
---@field auto_update boolean? Automatically update package if update available

---@alias config.lsp.Server.MasonConfig string | MasonConfig

---@alias config.lsp.Handler.Config boolean | fun(): nil

---`true` means default setup
---
---Function is the setup handler with parameter `info` of type `table`, which holds `lspconfig`. Set it up yourself.
---This is for custom setup
---
---`table` is for setup manually, This one is only useful when using mason
---It setup language server without install using mason
---Literally the "lspconfig way"
---The key `config` is yet another configuration, that is, one of those value
---
---`false` means ignore. When using mason, this will only install package but not setup.
---Otherwise this should same as nil
---@alias config.lsp.Handler config.lsp.Handler.Config | { config: config.lsp.Handler.Config? }

--- Setup LSP
---@param NAME_CONFIG_TABLE { [string]: config.lsp.Handler.Config }
local function lspconfig_setup(NAME_CONFIG_TABLE)
	for server_name, config in pairs(NAME_CONFIG_TABLE) do
		if type(config) == "boolean" then
			if config then
				-- Default setup
				vim.lsp.enable(server_name)
			end
		-- Do nothing if ignored
		elseif type(config) == "function" then
			-- Invoke custom setup
			config()
		else
			error("config type mismatched")
		end
	end
end

local function with_mason()
	local mason_lspconfig = require("mason-lspconfig")
	local mason_tool_installer = require("mason-tool-installer")
	-- Preparing begin

	---@type { [string]: config.lsp.Handler.Config }
	local handle_by_mason = {}
	---@type config.lsp.Server.MasonConfig[]
	local ensure_installed = {}
	---@type { [string]: config.lsp.Handler.Config }
	local manual_setup = {}
	for server_config, handler in pairs(server_config_table) do
		local server_name = server_config
		if type(server_config) == "table" then
			-- Extract server_name from `config.lsp.Server.MasonConfig`
			server_name = server_config[1]
		end
		assert(type(server_name) == "string")

		if type(handler) == "table" then
			-- Put manual ones into manual_setup instead of ensure_installed
			manual_setup[server_name] = handler.config
			goto continue
		else
			-- Put all others into ensure_installed
			table.insert(ensure_installed, server_config)
			if handler ~= false then
				-- Skip `false` for installing only
				handle_by_mason[server_name] = handler
			end
		end
		::continue::
	end

	-- This has better customize options
	mason_tool_installer.setup({
		ensure_installed = ensure_installed,

		-- if set to true this will check each tool for updates. If updates
		-- are available the tool will be updated. This setting does not
		-- affect :MasonToolsUpdate or :MasonToolsInstall.
		-- Default: false
		auto_update = false,

		-- automatically install / update on startup. If set to false nothing
		-- will happen on startup. You can use :MasonToolsInstall or
		-- :MasonToolsUpdate to install tools and check for updates.
		-- Default: true
		run_on_start = true,

		-- set a delay (in ms) before the installation starts. This is only
		-- effective if run_on_start is set to true.
		-- e.g.: 5000 = 5 second delay, 10000 = 10 second delay, etc...
		-- Default: 0
		start_delay = 10000,

		-- Only attempt to install if 'debounce_hours' number of hours has
		-- elapsed since the last time Neovim was started. This stores a
		-- timestamp in a file named stdpath('data')/mason-tool-installer-debounce.
		-- This is only relevant when you are using 'run_on_start'. It has no
		-- effect when running manually via ':MasonToolsInstall' etc....
		-- Default: nil
		debounce_hours = nil,

		-- By default all integrations are enabled. If you turn on an integration
		-- and you have the required module(s) installed this means you can use
		-- alternative names, supplied by the modules, for the thing that you want
		-- to install. If you turn off the integration (by setting it to false) you
		-- cannot use these alternative names. It also suppresses loading of those
		-- module(s) (assuming any are installed) which is sometimes wanted when
		-- doing lazy loading.
		integrations = {
			["mason-lspconfig"] = true,
			["mason-null-ls"] = false,
			["mason-nvim-dap"] = false, -- TODO: Change to true after dap integration is done
		},
	})

	-- Preparing end

	-- LSP server begin
  --[[ 
	local handler = {}

	for server_name, config in pairs(handle_by_mason) do
		if config == true then
			handler[server_name] = function()
				lspconfig[server_name].setup({})
			end
		else
			handler[server_name] = function()
				config()
			end
		end
	end
  ]]

  mason_lspconfig.setup({
		-- A list of servers to automatically install if they're not already installed.
		-- Example: { "rust_analyzer@nightly", "lua_ls" }
		--
		-- This setting has no relation with the `automatic_installation` setting.
		---@type string[]
		ensure_installed = {},

		-- Whether servers that are set up (via lspconfig) should be automatically installed
		-- if they're not already installed.
		--
		-- This setting has no relation with the `ensure_installed` setting.
		-- Can either be:
		--   - false: Servers are not automatically installed.
		--   - true: All servers set up via lspconfig are automatically installed.
		--   - { exclude: string[] }:
		--        All servers set up via lspconfig,
		--        except the ones provided in the list, are automatically installed.
		--        Example: automatic_installation = { exclude = { "rust_analyzer", "solargraph" } }
		---@type boolean
		automatic_installation = false,
	})

  -- Setup mason installed servers
  lspconfig_setup(handle_by_mason)

	-- Setup manually
	lspconfig_setup(manual_setup)

	-- LSP server end
end

local function lspconfig_only()
	-- Preparing begin

	local name_config_table = {}
	for k, v in pairs(server_config_table) do
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
	-- Preparing end

	-- LSP server begin

	lspconfig_setup(name_config_table)

	-- LSP server end
end

-- Append required capabilities
lspconfig.util.default_config = Table.merge("force", lspconfig.util.default_config, {
	capabilities = Table.deep_merge(
		"force",
		vim.lsp.protocol.make_client_capabilities(),
		require("lsp-file-operations").default_capabilities(),
		require("cmp_nvim_lsp").default_capabilities(),
		-- UFO default capabilities
		{
			textDocument = {
				foldingRange = {
					dynamicRegistration = false,
					lineFoldingOnly = true,
				},
			},
		}
	),
})

-- Setup LSP
if profile.preference.use_mason then
	with_mason()
else
	lspconfig_only()
end
