vim.api.nvim_create_autocmd("VimEnter", {
  group = Vkzlib.vim.augroup("lazy_", "autoupdate"),
  callback = function ()
    if require("lazy.status").has_updates then
      require("lazy").update({ show = false })
    end
  end
})
