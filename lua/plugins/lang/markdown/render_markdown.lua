return {
  'MeanderingProgrammer/render-markdown.nvim',
  ft = { "markdown", "norg", "rmd", "org" },
  dependencies = {
    require("plugins.treesitter"),
    require("plugins.libs.web_devicons")
  },
  opts = {},
}
