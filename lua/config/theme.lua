local profile = require("profiles")

local colorscheme = profile.THEME
-- local main_menu = require("config.options").main_menu
local main_menu = require("config.menu." .. profile.MENU).config

vim.cmd.colorscheme(colorscheme)

require'alpha'.setup(main_menu)

--[[
-- For unknown reason, when using some themes,
-- selected text doesn't highlighted in visual mode after window focus changed.
-- This is the workaround for that.
--]]
vim.api.nvim_create_autocmd({ "FocusGained" }, {
  group = Vkzlib.vim.augroup("theme", "fix_visual"),
  pattern = "*",
  command = "hi link Visual NONE"
})

