-- Linters for filetypes
-- See statusline for filetype of current file

-- local linters = {
--   lua = { "luacheck" },
--   python = { "flake8", "bandit" }, -- Mason doesn't include bandit yet
--   haskell = { "hlint" },
-- }

-- Use `nvim-lint.nvim`
local lint = require("lint")
local linters = require("profiles").languages.linters
assert(linters ~= nil, "Profile with invalid linters")

lint.linters_by_ft = linters

-- Setup autocmd to trigger lint
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    -- try_lint without arguments runs the linters defined in `linters_by_ft`
    -- for the current filetype
    lint.try_lint()

    -- You can call `try_lint` with a linter name or a list of names to always
    -- run specific linters, independent of the `linters_by_ft` configuration
    -- require("lint").try_lint("cspell")
  end,
})
