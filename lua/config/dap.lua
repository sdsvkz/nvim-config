-- TODO: Load this in config.init
local dap = require("dap")
local dapui = require("dapui")
local mason_dap = require("mason-nvim-dap")

local profile = require("profiles")
local options = require("profiles.options")

dap.adapters.codelldb = {
  type = "executable",
  command = "codelldb", -- or if not in $PATH: "/absolute/path/to/codelldb"

  -- On windows you may have to uncomment this:
  detached = profile.preference.os == options.System.Windows,
}
