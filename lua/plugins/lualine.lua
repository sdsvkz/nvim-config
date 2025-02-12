return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    require("plugins.libs.web_devicons"),
    require("plugins.auto_session"),
  },
  opts = {
    options = {
      theme = "auto",
    },
    sections = {
      lualine_a = {'mode', 'diagnostics'},
      lualine_b = {
        'branch',
        function()
          return require('auto-session.lib').current_session_name(true)
        end,
        'diff',
      },
      lualine_c = {},
      lualine_x = {'filename', 'filetype'},
      lualine_y = {'encoding'},
      lualine_z = {'location'}
    },
    -- tabline = {
    --   lualine_a = {'buffers'},
    --   lualine_b = {},
    --   lualine_c = {},
    --   lualine_x = {},
    --   lualine_y = {},
    --   lualine_z = {'tabs'}
    -- },
    extensions = {
      'lazy',
      "mason",
      "nvim-dap-ui",
      'nvim-tree',
      'toggleterm',
      "trouble",
      'quickfix',
    },
    lsp_saga = true,
  }
}
