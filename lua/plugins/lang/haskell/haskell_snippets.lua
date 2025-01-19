return {
  "mrcjkb/haskell-snippets.nvim",
  dependencies = {
    require("plugins.luaSnip")
  },
  ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
  config = function()
    local haskell_snippets = require("haskell-snippets").all
    require("luasnip").add_snippets("haskell", haskell_snippets, { key = "haskell" })
  end,
}
