local merge_plugin_opts = require("profiles.utils").merge_plugin_opts

local Groups = require("config.key_groups").Groups

local filter = Vkz.vkzlib.Data.list.filter

local opts = {
	open_mapping = false,
	insert_mappings = false,
}

---@module "toggleterm"

local function Term()
	return require("toggleterm.terminal")
end

---@param direction 'vertical' | 'horizontal' | 'tab' | 'float'
---@return fun(step: integer)?
local function get_cycle_action_on_direction(direction)
	if direction ~= "vertical" and direction ~= "horizontal" then
		Vkz.log.w("get_cycle_action_on_direction can only provide action for vertical or horizontal terminal")
		return nil
	end

	---@param step integer
	return function(step)
		local Terminal = Term()
		local terms = Terminal.get_all(false)
		if not terms or vim.tbl_isempty(terms) then
			return
		end

    ---@type Terminal[]
		local filtered = filter(function(term)
			---@cast term Terminal
			return term.direction == direction
		end, terms)

		if vim.tbl_isempty(filtered) then
			return
		end

		local current_buf = vim.api.nvim_get_current_buf()
		local index = Vkz.vkzlib.Data.list.findIndex(function(x)
			---@cast x Terminal
			return x.bufnr == current_buf
		end, filtered)

    if index == nil then
      return
    end

    index = ((index + step - 1) % #filtered) + 1

    local term = filtered[index]
		if type(term) == "table" and type(term.window) == "number" then
		  vim.api.nvim_set_current_win(term.window)
		end
	end
end

local cycle_horizontal_terminal = get_cycle_action_on_direction("horizontal")

local lazygit = (function()
	local res = nil
	return function()
		if res ~= nil then
			return res
		end
		local Terminal = require("toggleterm.terminal").Terminal
		local lazygit = Terminal:new({
			cmd = "lazygit",
			hidden = true,
			direction = "float",
		})
		res = lazygit
		return res
	end
end)()

---@type LazyKeysSpec[]
local keys = {
	{
		Groups.UI.lhs .. "t",
		mode = { "n", "t" },
		[[<CMD>ToggleTerm direction=float<CR>]],
		desc = "Toggle floating terminal",
	},
	{
		Groups.UI.lhs .. "Tn",
		mode = { "n", "t" },
		[[<CMD>TermNew<CR>]],
		desc = "Open new terminal",
	},
	{
		Groups.UI.lhs .. "Ts",
		mode = { "n", "t" },
		[[<CMD>TermSelect<CR>]],
		desc = "Select terminal",
	},
	{
		Groups.UI.lhs .. "g",
		mode = { "n", "t" },
		function()
			lazygit():toggle()
		end,
		desc = "Toggle Lazygit session",
		buffer = 0,
		noremap = true,
		silent = true,
	},
	{
		[[<C-/>]],
		mode = { "t" },
		[[<C-\><C-n>]],
		desc = "Switch back to normal mode",
		buffer = 0,
		noremap = true,
		silent = true,
	},
	{
		"<C-h>",
		mode = { "t" },
		"<CMD>wincmd h<CR>",
		desc = "Go to the left window",
		buffer = 0,
		noremap = true,
		silent = true,
	},
	{
		"<C-j>",
		mode = { "t" },
		"<CMD>wincmd j<CR>",
		desc = "Go to the down window",
		buffer = 0,
		noremap = true,
		silent = true,
	},
	{
		"<C-k>",
		mode = { "t" },
		"<CMD>wincmd k<CR>",
		desc = "Go to the up window",
		buffer = 0,
		noremap = true,
		silent = true,
	},
	{
		"<C-l>",
		mode = { "t" },
		"<CMD>wincmd l<CR>",
		desc = "Go to the right window",
		buffer = 0,
		noremap = true,
		silent = true,
	},
	{
		"<c-w>",
		mode = { "t" },
		[[<C-\><C-n><C-w>]],
		desc = "window",
		buffer = 0,
		noremap = true,
		silent = true,
	},
}

if cycle_horizontal_terminal then
	table.insert(keys, {
		"<C-Tab>",
		mode = "t",
		function()
			cycle_horizontal_terminal(1)
		end,
		desc = "Cycle next terminal (Horizontal)",
	})
end

---@type LazyPluginSpec
return {
	"akinsho/toggleterm.nvim",
	opts = merge_plugin_opts(Vkz.vkzlib.io.lua.get_caller_module_path(), opts),
	cmd = {
		"ToggleTerm",
		"ToggleTermToggleAll",
		"TermExec",
		"TermNew",
		"TermSelect",
		"ToggleTermSendCurrentLine",
		"ToggleTermSendVisualLines",
		"ToggleTermSendVisualSelection",
		"ToggleTermSetName",
	},
	keys = keys,
}
