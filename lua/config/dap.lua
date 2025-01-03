-- TODO: Load this in config.init
local dap = require("dap")
local dapui = require("dapui")
local mason_dap = require("mason-nvim-dap")

local profile = require("profiles")
local options = require("profiles.options")

dapui.setup()

-- Use nvim-dap events to open and close windows automatically
dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end
