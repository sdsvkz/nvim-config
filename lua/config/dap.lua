---@module "dap"

---@alias config.dap.Config.Adapters table<config.mason.InstallConfig, dap.Adapter | dap.AdapterFactory>

---@class config.dap.Config
---Adapters for this language
---Map adapter name or `MasonInstallConfig` for the adapter to it's configuration
---@field adapters config.dap.Config.Adapters
---DAP Configuration for language's filetypes
---@field configurations table<string, dap.Configuration[]>
