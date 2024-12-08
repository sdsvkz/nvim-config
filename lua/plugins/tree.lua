return {
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    init = function ()
      -- disable netrw
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    opts = {
      actions = {
        open_file = {
          quit_on_open = true
        }
      }
    },
    keys = {
      {
        '<leader>e', mode = 'n',
        '<CMD>NvimTreeToggle<CR>',
        desc = "Toggle file explorer"
      },
      {
        '<leader>E', mode = 'n',
        '<CMD>NvimTreeFindFile<CR>',
        desc = "Show current file in file explorer"
      }
    }
  },
  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      require("plugins.libs.plenary"),
    },
    config = function()
      require("lsp-file-operations").setup()
    end,
  },
}
