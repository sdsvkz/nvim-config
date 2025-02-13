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

      -- Make :bd and :q behave as usual when tree is visible
      -- https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#make-q-and-bd-work-as-if-tree-was-not-visible
      vim.api.nvim_create_autocmd({'BufEnter', 'QuitPre'}, {
        nested = false,
        callback = function(e)
          local tree = require('nvim-tree.api').tree

          -- Nothing to do if tree is not opened
          if not tree.is_visible() then
            return
          end

          -- How many focusable windows do we have? (excluding e.g. incline status window)
          local winCount = 0
          for _,winId in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_config(winId).focusable then
              winCount = winCount + 1
            end
          end

          -- We want to quit and only one window besides tree is left
          if e.event == 'QuitPre' and winCount == 2 then
            vim.api.nvim_cmd({cmd = 'qall'}, {})
          end

          -- :bd was probably issued an only tree window is left
          -- Behave as if tree was closed (see `:h :bd`)
          if e.event == 'BufEnter' and winCount == 1 then
            -- Required to avoid "Vim:E444: Cannot close last window"
            vim.defer_fn(function()
              -- close nvim-tree: will go to the last buffer used before closing
              tree.toggle({find_file = true, focus = true})
              -- re-open nivm-tree
              tree.toggle({find_file = true, focus = false})
            end, 10)
          end
        end
      })
    end,

    opts = {
      filesystem_watchers = {
        ignore_dirs = {
          "node_modules", "AppData"
        },
      },
      git = {
        timeout = 5000,
      },
      actions = {
        open_file = {
          quit_on_open = true,
        },
      },
      sync_root_with_cwd = true,
    },

    keys = {
      {
        Groups.UI.lhs .. 'e', mode = 'n',
        '<CMD>NvimTreeToggle<CR>',
        desc = "Toggle file explorer",
      },
      {
        Groups.UI.lhs .. 'E', mode = 'n',
        '<CMD>NvimTreeFindFile<CR>',
        desc = "Show current file in file explorer",
      },
    },

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
