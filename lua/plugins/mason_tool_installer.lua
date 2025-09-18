local lsp = require("config.lsp")
local lint = require("config.lint")

local deep_merge = Vkz.vkzlib.Data.table.deep_merge

local profile = require("profiles")


---Options of Mason package
---@class (exact) MasonInstallConfig
---@field [1] string Package name
---@field version string? Package version
---@field auto_update boolean? Automatically update package if update available
---@field condition (fun(): boolean)? Conditional installing
---@field no_mason integer? Don't use mason if set

---@alias config.mason.InstallConfig string | MasonInstallConfig

local opts = {
	ensure_installed = deep_merge("force", lsp.ensure_installed, lint.ensure_installed),

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
		["mason-nvim-dap"] = true,
	},
}

---@type LazyPluginSpec
return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	enabled = profile.preference.use_mason == true,
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"jay-babu/mason-nvim-dap.nvim",
	},
  opts = profile.utils.merge_plugin_opts(Vkz.vkzlib.io.lua.get_caller_module_path(), opts)
}
