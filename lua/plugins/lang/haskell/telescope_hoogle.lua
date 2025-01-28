return {
  "luc-tielen/telescope_hoogle",
  ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
  config = function ()
    local telescope = require('telescope')
    telescope.load_extension('hoogle')
  end,
  dependencies = {
    require("plugins.telescope")
  }
}
