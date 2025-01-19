return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    require("plugins.libs.plenary"),
    require("plugins.libs.ripgrep"),
  }
}
