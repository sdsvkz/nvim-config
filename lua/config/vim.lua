local profile = require("profiles")

vim.o.termguicolors = true -- Enable 24-bit colour. Required by some plugins, such as toggleterm.nvim
vim.o.signcolumn = "yes" -- Keep leftmost sign column on to avoid "shaking"

local LINE_NUMBERING = profile.editor.line_numbering
local TAB_SIZE = profile.editor.tab_size
local EXPAND_TAB = profile.editor.expand_tab_to_spaces
local AUTO_INDENT = profile.editor.auto_indent

vim.o.number = LINE_NUMBERING -- Line numbering
vim.o.tabstop = TAB_SIZE
vim.o.softtabstop = TAB_SIZE -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = TAB_SIZE -- Number of spaces inserted when indenting
vim.o.expandtab = EXPAND_TAB -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.autoindent = AUTO_INDENT -- Copy indent from current line when starting a new line
vim.o.smartindent = AUTO_INDENT -- Try to track indenting level

