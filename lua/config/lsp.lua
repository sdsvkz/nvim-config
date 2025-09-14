local profile = require("profiles")
local Table = Vkz.vkzlib.Data.table

local server_config_table = profile.languages.ls
assert(server_config_table ~= nil, "Profile with invalid language server config")

---@alias config.lsp.Handler.Config boolean | fun(): nil

---`true` means default setup
---
---Function is the setup handler. Set up language server in here.
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

---@class (exact) config.lsp.LspConfig
---@field ensure_installed config.mason.InstallConfig[]
---@field handle_by_mason table<string, config.lsp.Handler.Config>
---@field manual_setup table<string, config.lsp.Handler.Config>

local function common_setup()
  local lspconfig = require("lspconfig")

	-- Set LSP inlay hint
	if profile.preference.enable_inlay_hint then
		vim.lsp.inlay_hint.enable()
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
end

--- Setup LSP
---@param NAME_CONFIG_TABLE table<string, config.lsp.Handler.Config>
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

---@param HANDLE_BY_MASON table<string, config.lsp.Handler.Config>
---@param MANUAL_SETUP table<string, config.lsp.Handler.Config>
local function with_mason(HANDLE_BY_MASON, MANUAL_SETUP)
  common_setup()

	-- Setup mason installed servers
	lspconfig_setup(HANDLE_BY_MASON)

	-- Setup manually
	lspconfig_setup(MANUAL_SETUP)
end

---@param NAME_CONFIG_TABLE table<string, config.lsp.Handler.Config>
local function lspconfig_only(NAME_CONFIG_TABLE)
  common_setup()
	lspconfig_setup(NAME_CONFIG_TABLE)
end

-- Set LSP inlay hint
if profile.preference.enable_inlay_hint then
	vim.lsp.inlay_hint.enable()
end

---@type config.lsp.LspConfig
local M = {
	lspconfig_setup = lspconfig_setup,
	setup = {
		with_mason = with_mason,
		lspconfig_only = lspconfig_only,
	},
	ensure_installed = {},
	handle_by_mason = {},
	manual_setup = {},
}

-- Setup LSP
if profile.preference.use_mason then
	local res = profile.utils.extract_mason_lspconfig(server_config_table)
	M.ensure_installed = res.ensure_installed
	M.handle_by_mason = res.handle_by_mason
	M.manual_setup = res.manual_setup
else
	M.manual_setup = profile.utils.extract_lspconfigs(server_config_table)
end

return M
