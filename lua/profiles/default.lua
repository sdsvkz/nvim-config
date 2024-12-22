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

---@class profiles.Profile
---@field preference profiles.Profile.Preference
---@field editor profiles.Profile.Editor
---@field appearence profiles.Profile.Appearence
---@field language profiles.Profile.Language
---@field debugging profiles.Profile.Debugging

---@class profiles.Profile.Preference
---@field os Profiles.Options.System
---@field use_mason boolean

---@class profiles.Profile.Editor
---@field line_numbering boolean
---@field expand_tab_to_spaces boolean
---@field tab_size integer
---@field auto_indent boolean

---@class profiles.Profile.Appearence
---@field theme string
---@field menu string

-- TODO: Complete language options
-- This should let user enable what language to use.
-- Profile should enable some tools for language being chosen
-- User should be able to exclude or include some optional tools

---@class profiles.Profile.Language

---@class profiles.Profile.Debugging
---@field enable_test boolean
---@field log_level vkzlib.logging.Logger.Level

---@type profiles.Profile
return {
  -- Preference
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

  -- Appearence
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

  -- Language
  language = {

  },

  -- Debugging
  debugging = {
    ---Whether enable test module of `vkzlib`
    ---@type boolean
    enable_test = false,

    ---Log level for `vkzlib.logging`
    ---@type vkzlib.logging.Logger.Level
    log_level = "info"
  },
}
