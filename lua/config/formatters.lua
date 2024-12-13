-- Formatters of filetypes
-- See statusline for filetype of current file
-- TODO: Put into profile
local formatters = {
  lua = { "stylua" },
  -- Conform will run multiple formatters sequentially
  python = { "isort", "black" },
  -- You can customize some of the format options for the filetype (:help conform.format)
  -- rust = { "rustfmt", lsp_format = "fallback" },
  -- Conform will run the first available formatter
  -- javascript = { "prettierd", "prettier", stop_after_first = true },

  -- haskell = { "ormolu" }, -- HLS use Ormolu as built-in formatter
}

return formatters
