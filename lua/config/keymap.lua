local Groups = require("config.key_groups").Groups
local Mappings = require("config.key_groups").Mappings
local wk = require("which-key")
local dap = require("dap")
local dap_widgets = require("dap.ui.widgets")
local dapui = require("dapui")

wk.add(Mappings)

-- Set

Groups.Editing.set("n", "F", function() return vim.lsp.buf.format() end, { desc = "LSP: Format buffer" })

Groups.Setting.set("n", "l", "<CMD>Lazy<CR>", { desc = "Lazy home" })

Groups.Debugging.set('n', 'dc', function() dap.continue() end, {
  desc = "Launching debug sessions or resuming execution"
})
Groups.Debugging.set('n', 'n', function() dap.step_over() end, {
  desc = "Step over the current line"
})
Groups.Debugging.set('n', 'i', function() dap.step_into() end, {
  desc = "Step into a function or method"
})
Groups.Debugging.set('n', 'o', function() dap.step_out() end, {
  desc = "Step out of a function or method"
})
Groups.Debugging.set('n', 'b', function() dap.toggle_breakpoint() end, {
  desc = "Creates or removes a breakpoint at the current line."
})
Groups.Debugging.set('n', 'B', function() dap.set_breakpoint() end, {
  desc = "Create a breakpoint"
})
Groups.Debugging.set('n', 'l',
  function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end,
  {
    desc = "Create a log point"
  }
)
Groups.Debugging.set('n', 'r', function() dap.repl.open() end, {
  desc = "Open a REPL / Debug-console."
})
Groups.Debugging.set('n', 'dl', function() dap.run_last() end, {
  desc = "Run the last debug session again"
})
Groups.Debugging.set({'n', 'v'}, 'h', function()
  dap_widgets.hover()
end, { desc = "View the value for the expression under the cursor (Hover)" })
Groups.Debugging.set({'n', 'v'}, 'p', function()
  dap_widgets.preview()
end, { desc = "View the value of the expression under the cursor (Preview)" })
Groups.Debugging.set('n', 'f', function()
  dap_widgets.centered_float(dap_widgets.frames)
end, { desc = "Frames" })
Groups.Debugging.set('n', 's', function()
  dap_widgets.centered_float(dap_widgets.scopes)
end, { desc = "Scopes" })

Groups.UI.set("n", "D", function() return dapui.toggle() end, {
  desc = "Toggle all debugging windows"
})
