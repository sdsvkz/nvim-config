local options = require("config.options")

local colorscheme = options.theme
-- local main_menu = require("config.options").main_menu
local main_menu = require("config.menu." .. options.main_menu).config

vim.cmd.colorscheme(colorscheme)

require'alpha'.setup(main_menu)

-- Workaround for visual highlight issue
vim.api.nvim_create_autocmd({ "FocusGained" }, {
  group = Vkzlib.vim.augroup("theme", "fix_visual"),
  pattern = "*",
  command = "hi link Visual NONE"
})

