local wk = require("which-key")
local dap = require("dap")
local dap_widgets = require("dap.ui.widgets")
local dapui = require("dapui")

wk.add {
  -- Groups
  { "<LEADER>,", group = "Setting" },
  { "<LEADER>x", group = "UIs" },
  { "<LEADER>s", group = "Show / Send" },
  { "<LEADER>g", group = "Goto / Generate" },
  { "<LEADER>p", group = "Peek" },
  { "<LEADER>d", group = "Debugging" }
}

vim.keymap.set("n", "<LEADER>,l", "<CMD>Lazy<CR>", { desc = "Lazy home" })
vim.keymap.set("n", "<LEADER>F", function() return vim.lsp.buf.format() end, { desc = "LSP: Format buffer" })

-- Debugging keymap
vim.keymap.set('n', '<LEADER>ddc', function() dap.continue() end, {
  desc = "Launching debug sessions or resuming execution"
})
vim.keymap.set('n', '<LEADER>dn', function() dap.step_over() end, {
  desc = "Step over the current line"
})
vim.keymap.set('n', '<LEADER>di', function() dap.step_into() end, {
  desc = "Step into a function or method"
})
vim.keymap.set('n', '<LEADER>do', function() dap.step_out() end, {
  desc = "Step out of a function or method"
})
vim.keymap.set('n', '<Leader>db', function() dap.toggle_breakpoint() end, {
  desc = "Creates or removes a breakpoint at the current line."
})
vim.keymap.set('n', '<Leader>dB', function() dap.set_breakpoint() end, {
  desc = "Create a breakpoint"
})
vim.keymap.set('n', '<Leader>dl',
  function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end,
  {
    desc = "Create a log point"
  }
)
vim.keymap.set('n', '<Leader>dr', function() dap.repl.open() end, {
  desc = "Open a REPL / Debug-console."
})
vim.keymap.set('n', '<Leader>ddl', function() dap.run_last() end, {
  desc = "Run the last debug session again"
})
vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
  dap_widgets.hover()
end, { desc = "View the value for the expression under the cursor (Hover)" })
vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
  dap_widgets.preview()
end, { desc = "View the value of the expression under the cursor (Preview)" })
vim.keymap.set('n', '<Leader>df', function()
  dap_widgets.centered_float(dap_widgets.frames)
end, { desc = "Frames" })
vim.keymap.set('n', '<Leader>ds', function()
  dap_widgets.centered_float(dap_widgets.scopes)
end, { desc = "Scopes" })
vim.keymap.set("n", "<LEADER>xD", function() return dapui.toggle() end, {
  desc = "Toggle all debugging windows"
})
