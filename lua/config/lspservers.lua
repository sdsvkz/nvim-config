return {
  -- Bash
  ["bashls"] = true,
  ["powershell_es"] = function (t)
    t.lspconfig.powershell_es.setup {
      capabilities = t.capabilities,
      bundle_path = "D:/PowerShellEditorServices",
      init_options = {
        enableProfileLoading = false
      }
    }
  end,
  -- C/C++
  ["clangd"] = true,
  ["cmake"] = true,
  -- Lua
  ["lua_ls"] = function (t)
    t.lspconfig.lua_ls.setup {
      capabilities = t.capabilities or nil,

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
  ["hls"] = true
}
