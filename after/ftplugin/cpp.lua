local profile = require("profiles")
local wk = require("which-key")

if profile.utils.is_ft_support_enabled(profile.languages.custom, "cpp") then
  if profile.utils.is_ft_support_enabled(profile.languages.custom, "cmake") then
    local bufnr = vim.api.nvim_get_current_buf()
    wk.add {
      { "<LEADER>cm", group = "CMake" }
    }
    vim.keymap.set("n", "cmg", "<CMD>CMakeGenerate<CR>", {
      desc = "Generate make system",
      silent = true,
      buffer = bufnr,
    })
    vim.keymap.set("n", "cmb", "<CMD>CMakeBuild<CR>", {
      desc = "Build targets",
      silent = true,
      buffer = bufnr,
    })
    vim.keymap.set("n", "cmr", "<CMD>CMakeRun<CR>", {
      desc = "Run targets",
      silent = true,
      buffer = bufnr,
    })
    vim.keymap.set("n", "cmt", "<CMD>CMakeRunTest<CR>", {
      desc = "Run Tests",
      silent = true,
      buffer = bufnr,
    })
  end
end
