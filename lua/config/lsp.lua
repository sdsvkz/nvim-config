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
  local manual_setup = {}
  local i = 1
  for server_name, opts in pairs(options.LSP_SERVER_CONFIG_TABLE) do
    if type(opts) == "table" and opts.manual_setup == true then
      manual_setup[server_name] = (opts.opts == nil) and true or opts.opts
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

  -- Manually setup
  for server_name, config in pairs(manual_setup) do
    if (type(config) == "boolean") then
      if (config) then
        lspconfig[server_name].setup {

        }
      end
    elseif (type(config) == "function") then
      config {
        lspconfig = lspconfig
      }
    else
      error("config type mismatched")
    end
  end
  -- LSP server end

else

  for k, v in pairs(options.LSP_SERVER_CONFIG_TABLE) do
    if type(v) == "table" then
      options.LSP_SERVER_CONFIG_TABLE[k] = (v.opts == nil) and true or v.opts
    end
  end

  -- LSP server begin

  -- Setup
  for server_name, config in pairs(options.LSP_SERVER_CONFIG_TABLE) do
    if (config == "boolean") then
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
