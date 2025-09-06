return {
	"luc-tielen/telescope_hoogle",
	ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
	config = function()
		require("telescope").load_extension("hoogle")
	end,
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
}
