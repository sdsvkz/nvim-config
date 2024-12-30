return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See https://github.com/folke/lazydev.nvim#%EF%B8%8F-configuration for more details
        "lazy.nvim",
      },
      integrations = {
        -- Fixes lspconfig's workspace management for LuaLS
        -- Only create a new workspace if the buffer is not part
        -- of an existing workspace or one of its libraries
        lspconfig = true,
        -- add the cmp source for completion of:
        -- `require "modname"`
        -- `---@module "modname"`
        cmp = true,
        -- same, but for Coq
        coq = false,
      },
    },
  },
  -- { -- optional blink completion source for require statements and module annotations
  --   "saghen/blink.cmp",
  --   opts = {
  --     sources = {
  --       -- add lazydev to your completion providers
  --       default = { "lazydev", "lsp", "path", "snippets", "buffer" },
  --       providers = {
  --         lazydev = {
  --           name = "LazyDev",
  --           module = "lazydev.integrations.blink",
  --           -- make lazydev completions top priority (see `:h blink.cmp`)
  --           score_offset = 100,
  --         },
  --       },
  --     },
  --   },
  -- }
  -- { "folke/neodev.nvim", enabled = false }, -- make sure to uninstall or disable neodev.nvim
}
