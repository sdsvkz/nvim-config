local colorscheme = "fluoromachine"

vim.cmd.colorscheme(colorscheme)

require'alpha'.setup(require'config.menu.theta_modified'.config)

-- Workaround for visual highlight issue
vim.api.nvim_create_autocmd({ "FocusGained" }, {
  group = Vkzlib.vim.augroup("theme", "fix_visual"),
  pattern = "*",
  command = "hi link Visual NONE"
})

