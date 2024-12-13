vim.o.number = true -- Line numbering
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 2 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 2 -- Number of spaces inserted when indenting
vim.o.signcolumn = "yes" -- Keep leftmost sign column on avoid "shaking"

-- TODO: Put into profile
-- Tab size = 2
local TAB_SIZE = 2
vim.o.tabstop = TAB_SIZE
vim.o.softtabstop = TAB_SIZE
vim.o.shiftwidth = TAB_SIZE
vim.o.expandtab = true -- Use spaces instead of tab
vim.o.autoindent = true -- Copy indent from current line when starting a new line
vim.o.smartindent = true -- Try to track indenting level

-- Required by some plugins, such as toggleterm.nvim
vim.o.termguicolors = true -- Enable 24-bit colour
