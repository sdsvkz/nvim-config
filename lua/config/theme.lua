local vkzlib = Vkz.vkzlib

local profile = require("profiles")

---@param highlight string[]
local function setup_indent_blankline(highlight)
	local hooks = require("ibl.hooks")

	if vim.g.colors_name:find("catppuccin") == nil then
		-- create the highlight groups in the highlight setup hook, so they are reset
		-- every time the colorscheme changes
		hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
			vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
			vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
			vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
			vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
			vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
			vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
			vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
		end)
	end

	local ibl_opts = profile.utils.merge_plugin_opts(vim.fn.stdpath("config") .. "/lua/plugins/indent_blankline.lua", {
		indent = { highlight = highlight },
		scope = {
			enabled = true,
		},
	})

	if type(ibl_opts) == "function" then
		local opts = {}
		ibl_opts = ibl_opts(require("plugins.indent_blankline"), opts) or opts
	end

	require("ibl").setup(ibl_opts)

	hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
end

local function setup_alpha()
	local alpha_opts = profile.utils.merge_plugin_opts(
		vim.fn.stdpath("config") .. "/lua/plugins/alpha.lua",
		require("config.menu." .. profile.appearence.menu).config
	)

	if type(alpha_opts) == "function" then
		local opts = {}
		alpha_opts = alpha_opts(require("plugins.alpha"), opts) or opts
	end

	require("alpha").setup(alpha_opts)
end

---@param highlight string[]
local function set_rainbow_delimiters_highlight(highlight)
	---@module "rainbow-delimiters"

	local rainbow_delimiters = vim.g.rainbow_delimiters
  if type(rainbow_delimiters) == "table" then
    rainbow_delimiters.highlight = highlight
    vim.g.rainbow_delimiters = rainbow_delimiters
  else
	  vim.g.rainbow_delimiters = {
      highlight = highlight,
    }
  end
end

local colorscheme = profile.appearence.theme.colorscheme
vim.cmd.colorscheme(colorscheme)

local highlight = {
	"RainbowRed",
	"RainbowYellow",
	"RainbowBlue",
	"RainbowOrange",
	"RainbowGreen",
	"RainbowViolet",
	"RainbowCyan",
}

setup_indent_blankline(highlight)
set_rainbow_delimiters_highlight(highlight)
setup_alpha()

--[[
-- For unknown reason, when using some themes,
-- selected text doesn't highlighted in visual mode after window focus changed.
-- This is the workaround for that.
--]]
vim.api.nvim_create_autocmd({ "FocusGained" }, {
	group = vkzlib.vim.augroup("theme", "fix_visual"),
	pattern = "*",
	command = "hi link Visual NONE",
})
