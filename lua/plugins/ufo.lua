return {
  "kevinhwang91/nvim-ufo",
  dependencies = {
    require("plugins.libs.promise_async")
  },
  lazy = false,
  init = function ()
    vim.o.foldcolumn = "1"
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
  end,
  keys = function ()
    local ufo = require("ufo")
    return {
      {
        "zR", mode = "n",
        ufo.openAllFolds,
        desc = "Open all folds",
      },
      {
        "zM", mode = "n",
        ufo.closeAllFolds,
        desc = "Close all folds",
      },
    }
  end
}
