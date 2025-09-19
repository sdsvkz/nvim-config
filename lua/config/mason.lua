---Options of Mason package
---@class (exact) MasonInstallConfig
---@field [1] string Package name
---@field version string? Package version
---@field auto_update boolean? Automatically update package if update available
---@field condition (fun(): boolean)? Conditional installing
---@field no_mason integer? Don't use mason if set

---@alias config.mason.InstallConfig string | MasonInstallConfig

