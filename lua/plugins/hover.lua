local profile = require("profiles")

return {
  "lewis6991/hover.nvim",
  init = function ()
    local hover = require("hover")

    -- Keymap
    vim.keymap.set(
      "n", "K",
      hover.hover,
      { desc = "hover.nvim" }
    )
    -- Useless with noice or notify
    -- Use `<C-w>w` instead
    -- vim.keymap.set(
    --   "n", "gK",
    --   hover.hover_select,
    --   { desc = "hover.nvim (select)" }
    -- )
    vim.keymap.set(
      "n", "<C-p>",
      ---@diagnostic disable-next-line: missing-parameter
      function() hover.hover_switch("previous") end,
      { desc = "hover.nvim (previous source)" }
    )
    vim.keymap.set(
      "n", "<C-n>",
      ---@diagnostic disable-next-line: missing-parameter
      function() hover.hover_switch("next") end,
      { desc = "hover.nvim (next source)" }
    )

    -- Mouse support
    if profile.preference.mouse ~= "" then
      vim.o.mousemoveevent = true
      vim.keymap.set('n', '<MouseMove>', hover.hover_mouse, { desc = "hover.nvim (mouse)" })
    end
  end,
  opts = {
    init = function()
      -- Require providers
      require("hover.providers.lsp")
      -- require('hover.providers.gh')
      -- require('hover.providers.gh_user')
      -- require('hover.providers.jira')
      -- require('hover.providers.dap')
      require('hover.providers.fold_preview')
      require('hover.providers.diagnostic')
      -- require('hover.providers.man')
      -- require('hover.providers.dictionary')
    end,
    preview_opts = {
      border = 'single'
    },
    -- Whether the contents of a currently open hover window should be moved
    -- to a :h preview-window when pressing the hover keymap.
    preview_window = false,
    title = true,
    mouse_providers = {
      'LSP'
    },
    mouse_delay = 500
  },
}
