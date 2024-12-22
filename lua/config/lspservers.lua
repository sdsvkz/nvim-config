local profile = require('profiles')
local options = require("profiles.options")

-- TODO:
-- Let configuration determine what LSP should be installed automatically
-- Otherwise, make it manual setup

-- Map of language server name to configuration
-- Use names from lspconfig, not mason

---@class (exact) MasonConfig
---@field [1] string
---@field version string?
---@field auto_update boolean?

---@alias config.lsp.Server.MasonConfig string | MasonConfig

---@alias config.lsp.Handler.Config boolean | fun(info: { lspconfig: table }): nil


---`true` means default setup
---
---Function is the setup handler with parameter `info` of type `table`, which holds `lspconfig`. Set it up yourself.
---This is for custom setup
---
---`table` is for setup manually, This one is only useful when using mason
---It setup language server without install using mason
---Literally the "lspconfig way"
---The key `config` is yet another configuration, that is, one of those value
---
---`false` means ignore, this should same as nil
---@alias config.lsp.Handler config.lsp.Handler.Config | { config: config.lsp.Handler.Config? }

---@type { [config.lsp.Server.MasonConfig]: config.lsp.Handler }
local windows_only = {
  -- Powershell Script
  ["powershell_es"] = function (t)
    t.lspconfig.powershell_es.setup {
      bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
      init_options = {
        enableProfileLoading = false
      }
    }
  end
}

---@type { [config.lsp.Server.MasonConfig]: config.lsp.Handler }
local linux_only = {
  -- Bash Script
  ["bashls"] = true
}

---@type { [config.lsp.Server.MasonConfig]: config.lsp.Handler }
local general = {
  -- C/C++
  [{ "clangd", auto_update = true }] = true,
  -- Lua
  [{ "lua_ls", auto_update = true }] = function (info)
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
            -- or pull in all of 'runtimepath'.
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
  [{ "pyright", auto_update = true }] = true,
  -- Haskell
  ["hls"] = {
    -- Use HLS from PATH for better customization
    -- Since only supported ghc versions can be used
    config = true
  },
  -- Json
  [{ "jsonls", auto_update = true }] = true,
}

---@type { [config.lsp.Server.MasonConfig]: config.lsp.Handler }
local additional = {}

if profile.preference.os == options.System.Windows then
  additional = windows_only
elseif profile.preference.os == options.System.Linux then
  additional = linux_only
end

return Vkzlib.table.merge('force', general, additional)
