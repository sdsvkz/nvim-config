return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'diagnostics'},
      lualine_c = {'branch', 'diff'},
      lualine_x = {'filename', 'filetype'},
      lualine_y = {'encoding'},
      lualine_z = {'location'}
    },
    extensions = {
      'quickfix',
      'lazy',
      'nvim-tree',
      'toggleterm'
    }
  }
}
