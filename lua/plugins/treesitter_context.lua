return {
  "nvim-treesitter/nvim-treesitter-context",
  event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  dependencies = {
    require("plugins.treesitter")
  },
}
