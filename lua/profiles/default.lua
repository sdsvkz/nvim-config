--[[
--
-- !!! You should only load this in your own profile, and, as READ-ONLY variable
-- If you want to assign any table in default profile to your own profile, deep copy it
-- I have not handle any possible change to default profile
--
-- !!! Don't modify this
-- Create you own profile, name don't matter, e.g. sdsvkz.lua
-- Return table with overrided options
-- Your profile will be merged with default profile
--
-- !!! You should only put one profile under this folder
-- If you want to disable other profile, you can change extension to others
-- e.g. sdsvkz.lua.disabled
--
-- !!! Don't use Vkzlib, as profile contains debugging flags
--
--]]

---@class profiles.Profile
local profile = {
  ---Preference
  ---@class profiles.Profile.Preference
  preference = {
    ---Operating system used
    ---Used for platform-specific features
    ---@type Profiles.Options.System
    ---@diagnostic disable-next-line: undefined-field
    os = vim.uv.os_uname().sysname,

    ---If `true` use mason to install tools, then configure language servers with mason-lspconfig
    ---Otherwise, configure all language servers with lspconfig
    ---@type boolean
    use_mason = true,
  },

  ---Editor
  ---@class profiles.Profile.Editor
  editor = {
    ---@type boolean
    ---
    ---@see vim.o.number
    line_numbering = true,

    ---@type boolean
    ---
    ---@see vim.o.expandtab
    expand_tab_to_spaces = true,

    ---@type integer
    ---
    ---@see vim.o.tabstop
    ---@see vim.o.softtabstop
    ---@see vim.o.shiftwidth
    tab_size = 4,

    ---@type boolean
    ---
    ---@see vim.o.autoindent
    ---@see vim.o.smartindent
    auto_indent = true,
  },

  ---Appearence
  ---@class profiles.Profile.Appearence
  appearence = {
    ---To get list of available themes
    ---Run `:lua for _, theme in ipairs(vim.fn.getcompletion("", "color")) do print(theme) end`
    ---@type string
    theme = "catppuccin",

    ---Put startup menus into "lua/config/menu"
    ---Choose here using file name without extension
    ---@type string
    menu = "theta_modified",
  },

  ---Languages
  ---@class profiles.Profile.Languages
  languages = {
    ---Supported language, map filetype into language options
    ---See statusline for filetype of current file
    ---e.g. `lua` for "*.lua", ".luacheckrc", etc
    ---
    ---@see profiles.Profile.Languages.Language
    ---@class profiles.Profile.Languages.Supported
    supported = {
      ---@class profiles.Profile.Languages.Language
      c = {
        ---Whether to use this language
        ---e.g. You can use this to implement platform
        ---@type boolean?
        enable = nil,
        ---@class profiles.Profile.Languages.Tools
        tools = {
          -- TODO: Add options to `formatters` and `linters`

          -- Formatters of this filetype
          ---@type [string]?
          formatters = nil,
          -- Linters of this filetype
          ---@type [string]?
          linters = nil,
          ---Map of language server name to configuration
          ---Use names from lspconfig, not mason
          ---@type { [config.lsp.Server.MasonConfig]: config.lsp.Handler }?
          ls = {
            [{ "clangd", auto_update = true }] = true,
          },
          -- TODO: Add dap config here after nvim-dap is added
        },
      },
      ---@type profiles.Profile.Languages.Language
      cpp = {
        tools = {
          ls = {
            [{ "clangd", auto_update = true }] = true,
          },
        },
      },
      ---@type profiles.Profile.Languages.Language
      haskell = {
        tools = {
          -- formatters = { "ormolu" }, -- HLS use Ormolu as built-in formatter
          linters = { "hlint" },
          ls = {
            ["hls"] = {
              -- Use HLS from PATH for better customization
              -- Since only supported ghc versions can be used
              config = true
            },
          },
        },
      },
      ---@type profiles.Profile.Languages.Language
      lua = {
        tools = {
          formatters = { "stylua" },
          linters = { "luacheck" },
          ls = {
            [{ "lua_ls", auto_update = true }] = function (info)
              info.lspconfig.lua_ls.setup {
                on_init = function(client)
                  local path = client.workspace_folders[1].name
                  ---@diagnostic disable-next-line: undefined-field
                  if vim.uv.fs_stat(path..'/.luarc.json') or vim.uv.fs_stat(path..'/.luarc.jsonc') then
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
          },
        },
      },
      ---@type profiles.Profile.Languages.Language
      json = {
        tools = {
          ls = {
            [{ "jsonls", auto_update = true }] = true,
          },
        },
      },
      ---@type profiles.Profile.Languages.Language
      ps1 = {
        tools = {
          ls = {
            ["powershell_es"] = function (t)
              t.lspconfig.powershell_es.setup {
                bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
                init_options = {
                  enableProfileLoading = false
                },
              }
            end,
          },
        },
      },
      ---@type profiles.Profile.Languages.Language
      python = {
        tools = {
          formatters = { "isort", "black" },
          linters = { "flake8", "bandit" },
          ls = {
            [{ "pyright", auto_update = true }] = true,
          },
        },
      },
      ---@type profiles.Profile.Languages.Language
      sh = {
        tools = {
          ls = {
            -- TODO: Figure out how to lead `bashls` to find `shellcheck` and `shfmt` installed by mason
            -- Install `shellcheck` and `shfmt` to enable linting and formatting respectively
            ["bashls"] = function (info)
              info.lspconfig.bashls.setup()
            end,
          },
        },
      },
    },

    ---Map filetype into language options
    ---Override this in your own profile. It will be merged with `supported`
    ---@type profiles.Profile.Languages.Supported | [profiles.Profile.Languages.Language]
    custom = {
      -- Example

      -- cpp = {
      --   enable = true,
      -- },
      -- haskell = {
      --   enable = true,
      -- },
      -- json = {
      --   enable = true,
      -- },
      -- lua = {
      --   enable = true,
      -- },
      -- python = {
      --   enable = true,
      --   ---@type profiles.Profile.Languages.Tools
      --   tools = {
      --     -- Override `formatters` here
      --     -- If set, this will be used instead of default `formatters`
      --     formatters = {},
      --   },
      -- },
      -- Load default using `local default = require("profiles.default")`
      -- ps1 = {
      --   enable = default.preference.os == "Windows_NT",
      -- },
      -- sh = {
      --   enable = default.preference.os == "Linux"
      -- },
    },

    --- !!! Don't touch those fields
    --- Those will be extracted automatically from fields above

    ---This should be extracted automatically from fields above
    ---@type string[]?
    formatters = nil,

    ---This should be extracted automatically from fields above
    ---@type string[]?
    linters = nil,

    ---This should be extracted automatically from fields above
    ---@type { [config.lsp.Server.MasonConfig]: config.lsp.Handler }?
    ls = nil,
  },

  ---Debugging
  ---@class profiles.Profile.Debugging
  debugging = {

  },
}

return profile
