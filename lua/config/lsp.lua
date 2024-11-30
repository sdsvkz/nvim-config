local lspconfig = require('lspconfig')
local options = require("config.options")
local server_config_table = require("config.lspservers")

lspconfig.util.default_config = Vkzlib.table.merge(
  'force',
  lspconfig.util.default_config,
  {
    capabilities = Vkzlib.table.deep_merge(
      "force",
      vim.lsp.protocol.make_client_capabilities(),
      require('lsp-file-operations').default_capabilities(),
      require('cmp_nvim_lsp').default_capabilities()
    )
  }
)

local function lspconfig_setup(SERVER_CONFIG_TABLE)
  for server_name, config in pairs(SERVER_CONFIG_TABLE) do
    if (type(config) == "boolean") then
      if (config) then
        -- Default setup
        lspconfig[server_name].setup {

        }
      end
      -- Do nothing if ignored
    elseif (type(config) == "function") then
      -- Invoke custom setup
      config {
        lspconfig = lspconfig
      }
    else
      error("config type mismatched")
    end
  end
end

local function use_mason()
  -- Preparing begin
  local handle_by_mason = {}
  local manual_setup = {}
  for server_name, opts in pairs(server_config_table) do
    if opts == false then
      -- Discard ignored
      goto continue
    elseif type(opts) == "table" then
      if opts.manual_setup == true then
        -- Put manual ones into manual_setup instead of ensure_installed
        manual_setup[server_name] = (opts.config == nil) and true or opts.config
        goto continue
      end
      -- If opts.manual_setup is false, then do nothing with it
    else
      -- Put those into ensure_installed
      handle_by_mason[server_name] = opts
    end
    ::continue::
  end

  require("mason-tool-installer").setup {
    ensure_installed = Vkzlib.table.keys(handle_by_mason)
  }
  -- Preparing end

  -- LSP server begin
  local handler = {
    -- Set up default handler
    function (server_name)
      lspconfig[server_name].setup {

      }
    end,
  }

  for server_name, config in pairs(handle_by_mason) do
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

  -- Setup manually
  lspconfig_setup(manual_setup)

  -- LSP server end
end

local function no_mason()
  -- Preparing begin
  for k, v in pairs(server_config_table) do
    if type(v) == "table" then
      server_config_table[k] = (v.config == nil) and true or v.config
    end
  end
  -- Preparing end

  -- LSP server begin

  lspconfig_setup(server_config_table)

  -- LSP server end

end

if options.USE_MASON then

  use_mason()

else

  no_mason()

end
