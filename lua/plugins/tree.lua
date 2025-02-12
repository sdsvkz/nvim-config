local Groups = require("config.key_groups").Groups

return {
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      require("plugins.libs.web_devicons"),
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
      },
      sync_root_with_cwd = true,
    },
    keys = {
      {
        Groups.UI.lhs .. 'e', mode = 'n',
        '<CMD>NvimTreeToggle<CR>',
        desc = "Toggle file explorer"
      },
      {
        Groups.UI.lhs .. 'E', mode = 'n',
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
