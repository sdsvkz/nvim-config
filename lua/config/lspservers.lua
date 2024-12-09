local profile = require('profiles')
local options = require("profiles.options")

-- TODO:
-- Let configuration determine what LSP should be installed automatically
-- Otherwise, make it manual setup

-- Map of language server name to configuration
-- Use names from lspconfig, not mason

--[
-- `true` means default setup
--
-- Function is the setup handler with parameter `info` of type `table`, which holds `lspconfig`. Set it up yourself.
-- This is for custom setup
--
-- `table` is for setup manually, This one is only useful when using mason
-- It setup language server without install using mason
-- Literally the "lspconfig way"
-- The key `manual_setup` should be true. Otherwise, ignore it
-- The key `config` is yet another configuration, that is, one of those value
--
-- `false` means ignore, this should same as nil_wrap
--]

---@type { [string]: boolean | function | {  } }
local windows_only = {
  -- Powershell Script
  ["powershell_es"] = function (t)
    t.lspconfig.powershell_es.setup {
      capabilities = t.capabilities,
      bundle_path = "~/AppData/Local/nvim-data/mason/packages/powershell-editor-services",
      init_options = {
        enableProfileLoading = false
      }
    }
  end
}

local linux_only = {
  -- Bash Script
  ["bashls"] = true
}

local general = {
  -- C/C++
  ["clangd"] = true,
  ["cmake"] = true,
  -- Lua
  ["lua_ls"] = function (info)
    info.lspconfig.lua_ls.setup {
      on_init = function(client)
        local path = client.workspace_folders[1].name
        ---@diagnostic disable-next-line: undefined-field
        if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
          return
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
          runtime = {
            -- Tell the language server which version of Lua you're using
            -- (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT'
          },
          -- Make the server aware of Neovim runtime files
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME
              -- Depending on the usage, you might want to add additional paths here.
              -- "${3rd}/luv/library"
              -- "${3rd}/busted/library",
            }
            -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
            -- library = vim.api.nvim_get_runtime_file("", true)
          }
        })
      end,

      settings = {
        Lua = {}
      }
    }
  end,
  -- Python
  ["pyright"] = true,
  -- Haskell
  ["hls"] = {
    -- Use HLS from PATH for better customization
    -- Since only supported ghc versions can be used
    manual_setup = true,
    -- config = true
  },
  -- Json
  ["jsonls"] = true,
}

local additional = {}

if profile.CURRENT_SYSTEM == options.System.Windows then
  additional = windows_only
elseif profile.CURRENT_SYSTEM == options.System.Linux then
  additional = linux_only
end

return Vkzlib.table.merge('force', general, additional)
