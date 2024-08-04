local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')
local options = require("config.options")

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
        capabilities = capabilities
      }
    end,
  }

  for server_name, config in pairs(options.LSP_SERVER_CONFIG_TABLE) do
    if (type(config) == "function") then
      -- Next, provide dedicated handler for specific servers.
      handler[server_name] = function ()
        config {
          lspconfig = lspconfig,
          capabilities = capabilities
        }
      end
    end
  end

  require('mason-lspconfig').setup_handlers(handler)
  -- LSP server end

else

  -- LSP server begin
  for server_name, config in pairs(options.LSP_SERVER_CONFIG_TABLE) do
    if (type(config) == "boolean") then
      if (config) then
        lspconfig[server_name].setup {
          capabilities = capabilities
        }
      end
    elseif (type(config) == "function") then
      options.LSP_SERVER_CONFIG_TABLE[server_name] {
        lspconfig = lspconfig,
        capabilities = capabilities
      }
    end
  end
  -- LSP server end

end
