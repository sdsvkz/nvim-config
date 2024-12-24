--[[
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

-- TODO: Complete language options
-- This should let user enable what language to use.
-- Profile should enable some tools for language being chosen
-- User should be able to exclude or include some optional tools

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
    -- TODO: I need some utilities to turn this into usable datasets. Probably put them into profiles.utils

    ---@class profiles.Profile.Languages.Supported
    supported = {
      -- TODO: Set tools for languages

      ---@class profiles.Profile.Languages.Language
      c = {
        ---@type boolean
        enable = false,
        ---@class profiles.Profile.Languages.Tools
        tools = {
          ---@type [string]?
          formatters = nil,
          ---@type [string]?
          linters = nil,
          ---@type { [config.lsp.Server.MasonConfig]: config.lsp.Handler }?
          ls = nil,
          -- TODO: Add dap config here after nvim-dap is added
        },
      },
      ---@type profiles.Profile.Languages.Language
      cpp = {
        enable = false,
        tools = {},
      },
      ---@type profiles.Profile.Languages.Language
      haskell = {
        enable = false,
        tools = {},
      },
      ---@type profiles.Profile.Languages.Language
      lua = {
        enable = false,
        tools = {},
      },
      ---@type profiles.Profile.Languages.Language
      json = {
        enable = false,
        tools = {},
      },
      ---@type profiles.Profile.Languages.Language
      python = {
        enable = false,
        tools = {},
      },
    },

    ---@type profiles.Profile.Languages.Supported | [profiles.Profile.Languages.Language]
    custom = {

    },
  },

  -- TODO: vkzlib: Remove dependency of profile

  ---Debugging
  ---@class profiles.Profile.Debugging
  debugging = {
    ---Whether enable test module of `vkzlib`
    ---@type boolean
    enable_test = false,

    ---Log level for `vkzlib.logging`
    ---@type vkzlib.logging.Logger.Level
    log_level = "info"
  },
}

return profile
