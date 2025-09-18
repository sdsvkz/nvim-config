local Groups = require("config.key_groups").Groups
local Mappings = require("config.key_groups").Mappings
local wk = require("which-key")
local dap = require("dap")
local dap_widgets = require("dap.ui.widgets")
local dapui = require("dapui")

wk.add(Mappings)

vim.keymap.set({ "i", "c" }, "<C-v>", "<C-r>+", { desc = "Paste" })

Groups.Editing.set("n", "F", function()
	return vim.lsp.buf.format()
end, { desc = "LSP: Format buffer" })
Groups.Editing.set({ "n", "v" }, "c", '"+y', { desc = "Copy motion" })
Groups.Editing.set({ "n", "v" }, "C", '"+Y', { desc = "Copy line" })
Groups.Editing.set({ "n", "v" }, "x", '"+d', { desc = "Cut motion" })
Groups.Editing.set({ "n", "v" }, "X", '"+D', { desc = "Cut line" })
Groups.Editing.set("n", "v", '"+p', { desc = "Paste after cursor" })
Groups.Editing.set("n", "V", '"+P', { desc = "Paste before cursor" })
Groups.Editing.set("n", "H", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle inlay hints" })
Groups.Editing.set("n", "h", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end, { desc = "Toggle inlay hints (Buffer)" })
Groups.Editing.set("n", "r", function()
	vim.lsp.buf.rename()
end, { desc = "Rename symbol" })

Groups.Goto.set("n", "d", "<CMD>Telescope lsp_definitions<CR>", { desc = "Go to definition" })
Groups.Goto.set("n", "t", "<CMD>Telescope lsp_type_definitions<CR>", { desc = "Go to type definition" })

Groups.Setting.set("n", "l", "<CMD>Lazy<CR>", { desc = "Lazy home" })
Groups.Setting.set("n", "M", function()
	if vim.o.mouse == "" then
		vim.o.mouse = "niv"
	else
		vim.o.mouse = ""
	end
end, { desc = "Toggle mouse support" })

Groups.Debugging.set("n", "dc", function()
	dap.continue()
end, {
	desc = "Launching debug sessions or resuming execution",
})
Groups.Debugging.set("n", "n", function()
	dap.step_over()
end, {
	desc = "Step over the current line",
})
Groups.Debugging.set("n", "i", function()
	dap.step_into()
end, {
	desc = "Step into a function or method",
})
Groups.Debugging.set("n", "o", function()
	dap.step_out()
end, {
	desc = "Step out of a function or method",
})
Groups.Debugging.set("n", "b", function()
	dap.toggle_breakpoint()
end, {
	desc = "Creates or removes a breakpoint at the current line.",
})
Groups.Debugging.set("n", "B", function()
	dap.set_breakpoint()
end, {
	desc = "Create a breakpoint",
})
Groups.Debugging.set("n", "l", function()
	dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end, {
	desc = "Create a log point",
})
Groups.Debugging.set("n", "r", function()
	dap.repl.open()
end, {
	desc = "Open a REPL / Debug-console.",
})
Groups.Debugging.set("n", "dl", function()
	dap.run_last()
end, {
	desc = "Run the last debug session again",
})
Groups.Debugging.set({ "n", "v" }, "h", function()
	dap_widgets.hover()
end, { desc = "View the value for the expression under the cursor (Hover)" })
Groups.Debugging.set({ "n", "v" }, "p", function()
	dap_widgets.preview()
end, { desc = "View the value of the expression under the cursor (Preview)" })
Groups.Debugging.set("n", "f", function()
	dap_widgets.centered_float(dap_widgets.frames)
end, { desc = "Frames" })
Groups.Debugging.set("n", "s", function()
	dap_widgets.centered_float(dap_widgets.scopes)
end, { desc = "Scopes" })

Groups.UI.set("n", "D", function()
	return dapui.toggle()
end, {
	desc = "Toggle all debugging windows",
})

local function set_cmake_keymap()
	local bufnr = vim.api.nvim_get_current_buf()
	Groups.CMake.set("n", "g", "<CMD>CMakeGenerate<CR>", {
		desc = "Generate make system",
		silent = true,
		buffer = bufnr,
	})
	Groups.CMake.set("n", "b", "<CMD>CMakeBuild<CR>", {
		desc = "Build targets",
		silent = true,
		buffer = bufnr,
	})
	Groups.CMake.set("n", "r", "<CMD>CMakeRun<CR>", {
		desc = "Run targets",
		silent = true,
		buffer = bufnr,
	})
	Groups.CMake.set("n", "t", "<CMD>CMakeRunTest<CR>", {
		desc = "Run Tests",
		silent = true,
		buffer = bufnr,
	})
end

return {
	set_cmake_keymap = set_cmake_keymap,
}
