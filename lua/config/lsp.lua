local lspconfig = require('lspconfig')
local options = require("config.options")

lspconfig.util.default_config = vim.tbl_extend(
  'force',
  lspconfig.util.default_config,
  {
    capabilities = vim.tbl_deep_extend(
      "force",
      vim.lsp.protocol.make_client_capabilities(),
      require('lsp-file-operations').default_capabilities(),
      require('cmp_nvim_lsp').default_capabilities()
    )
  }
)

if options.USE_MASON then

  -- Ensure installed begin
  local ensure_installed = {}
  local i = 1
  for server_name, _ in pairs(options.LSP_SERVER_CONFIG_TABLE) do
    if false then
      goto continue
    else
      ensure_installed[i] = { server_name }
    end
    i = i + 1
    ::continue::
  end

  require("mason-tool-installer").setup {
    ensure_installed = ensure_installed
  }
  -- Ensure installed end

  -- LSP server begin
  local handler = {
    -- Set up default handler
    function (server_name)
      lspconfig[server_name].setup {

      }
    end,
  }

  for server_name, config in pairs(options.LSP_SERVER_CONFIG_TABLE) do
    if (type(config) == "function") then
      -- Next, provide dedicated handler for specific servers.
      handler[server_name] = function ()
        config {
          lspconfig = lspconfig
        }
      end
    end
  end

  require('mason-lspconfig').setup_handlers(handler)
  -- LSP server end

else

  -- LSP server begin

  -- Setup
  for server_name, config in pairs(options.LSP_SERVER_CONFIG_TABLE) do
    if (type(config) == "boolean") then
      if (config) then
        lspconfig[server_name].setup {

        }
      end
    elseif (type(config) == "function") then
      options.LSP_SERVER_CONFIG_TABLE[server_name] {
        lspconfig = lspconfig
      }
    else
      error("config type mismatched")
    end
  end
  -- LSP server end

end
