local profile = require("profiles")
local DAP = profile.languages.dap

assert(type(DAP) == "table", "Profile with invalid dap settings")

---@module "dap"

---@alias config.dap.Opts.Adapters table<config.mason.InstallConfig, dap.Adapter | dap.AdapterFactory>

---@class config.dap.Opts
---Adapters for this language
---Map adapter name or `MasonInstallConfig` for the adapter to it's configuration
---@field adapters config.dap.Opts.Adapters
---DAP Configuration for language's filetypes
---@field configurations table<string, dap.Configuration[]>

---@class (exact) config.dap.DapConfig
---@field ensure_installed config.mason.InstallConfig[]
---@field adapters table<string, dap.Adapter | dap.AdapterFactory>
---@field configurations table<string, dap.Configuration[]>

---@param ADAPTERS table<string, dap.Adapter | dap.AdapterFactory>
---@param CONFIGURATIONS table<string, dap.Configuration[]>
local function setup(ADAPTERS, CONFIGURATIONS)
	local dap = require("dap")
	dap.adapters = ADAPTERS
	dap.configurations = CONFIGURATIONS
end

---@type config.dap.DapConfig
local M = {
	setup = setup,
	ensure_installed = {},
	adapters = {},
	configurations = {},
}

local res = profile.utils.extract_dap(DAP)

M.ensure_installed = res.ensure_installed
M.adapters = res.adapters
M.configurations = res.configurations

return M
