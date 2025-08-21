local vkzlib = Vkz.vkzlib
local Table = vkzlib.Data.table

local lspconfig = require("lspconfig")
local profile = require("profiles")
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

local function with_mason()
	local mason_lspconfig = require("mason-lspconfig")
	-- Preparing begin

  local masonLspConfig = profile.utils.extract_mason_lspconfig(server_config_table)

	-- Preparing end

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
	lspconfig_setup(masonLspConfig.handle_by_mason)

	-- Setup manually
	lspconfig_setup(masonLspConfig.manual_setup)

	-- LSP server end

	return {
    ensure_installed = masonLspConfig.ensure_installed,
		handle_by_mason = masonLspConfig.handle_by_mason,
		manual_setup = masonLspConfig.manual_setup,
	}
end

local function lspconfig_only()
	-- Preparing begin

	local name_config_table = profile.utils.extract_lspconfigs(server_config_table)

  -- Preparing end

	-- LSP server begin

	lspconfig_setup(name_config_table)

	-- LSP server end

  return {
    manual_setup = name_config_table,
  }
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

---@type config.lsp.LspConfig
local M = {
  ensure_installed = {},
	handle_by_mason = {},
	manual_setup = {},
}

-- Setup LSP
if profile.preference.use_mason then
	---@return integer
	local res = with_mason()
  M.ensure_installed = res.ensure_installed
  M.handle_by_mason = res.handle_by_mason
  M.manual_setup = res.manual_setup
else
	M.manual_setup = lspconfig_only().manual_setup
end

return M

