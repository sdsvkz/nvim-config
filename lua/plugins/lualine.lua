return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    require("plugins.libs.web_devicons")
  },
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
    tabline = {
      lualine_a = {'buffers'},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {'tabs'}
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
