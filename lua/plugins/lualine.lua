return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      theme = "auto",
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'diagnostics'},
      lualine_c = {'branch', 'diff'},
      lualine_x = {'filename', 'filetype'},
      lualine_y = {'encoding'},
      lualine_z = {'location'}
    },
    extensions = {
      'lazy',
      "mason",
      'nvim-tree',
      'toggleterm',
      "trouble",
      'quickfix',
    },
    lsp_saga = true,
  }
}
