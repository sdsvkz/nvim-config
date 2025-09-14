---@enum Profiles.Options.System
local System = {
  Windows = "Windows_NT",
  Linux = "Linux",
  -- MacOS = "Darwin",
}

---@type table<string, profiles.Profile.Appearance.Theme>
local Themes = {}

Themes.catppuccin = {
  colorscheme = "catppuccin",
  plugin = "catppuccin",
}

---@module "catppuccin"
---@type CatppuccinOptions
---@diagnostic disable-next-line: inject-field, missing-fields
Themes.catppuccin.opts = {
  flavour = "auto",
  background = {
    light = "latte",
    dark = "mocha",
  },
  auto_integrations = true,
  integrations = {
    aerial = true,
    alpha = true,
    -- barbecue = { dim_dirname = true, bold_basename = true, dim_context = false, alt_background = false },
    cmp = true,
    -- dap = true,
    -- dap_ui = true,
    flash = true,
    gitsigns = {
      enabled = true,
      -- align with the transparent_background option by default
      -- transparent = false,
    },
    -- hop = true,
    illuminate = {
      -- Shit
      enabled = false,
      lsp = true,
    },
    indent_blankline = {
      enabled = true,
      scope_color = "pink", -- catppuccin color (eg. `lavender`) Default: text
      colored_indent_levels = true,
    },
    lsp_saga = false,
    lsp_trouble = true,
    markdown = true,
    mason = true,
    mini = {
      enabled = true,
      -- indentscope_color = "",
    },
    native_lsp = {
      enabled = true,
      virtual_text = {
        errors = { "italic" },
        hints = { "italic" },
        warnings = { "italic" },
        information = { "italic" },
        ok = { "italic" },
      },
      underlines = {
        errors = { "underline" },
        hints = { "underline" },
        warnings = { "underline" },
        information = { "underline" },
        ok = { "underline" },
      },
      inlay_hints = {
        background = true,
      },
    },
    -- neogit = true,
    -- neotree = true,
    notify = true,
    noice = true,
    nvimtree = true,
    rainbow_delimiters = true,
    render_markdown = true,
    semantic_tokens = true,
    telescope = {
      enabled = true,
      -- style = "nvchad"
    },
    treesitter = true,
    treesitter_context = true,
    ufo = true,
    -- vimwiki = true,
    which_key = true,
  },
}

Themes.catppuccin.theme_config = function (plugin)
  if type(plugin.setup) == "function" then
    plugin.setup(Themes.catppuccin.opts)
  end
end

Themes.fluoromachine = {
  plugin = "fluoromachine",
  colorscheme = "fluoromachine",
  theme_config = function (plugin)
    if type(plugin.setup) == "function" then
      plugin.setup({
        glow = true,
        theme = 'fluoromachine',
      })
    end
  end
}

Themes.moonfly = {
  plugin = "fluoromachine",
  colorscheme = "moonfly",
}

Themes.nightowl = {
  plugin = "night_owl",
  colorscheme = "night-owl",
  theme_config = function (plugin)
    if type(plugin.setup) == "function" then
      plugin.setup({})
    end
  end
}

Themes.tokyonight = {
  plugin = "tokyonight",
  colorscheme = "tokyonight",
  theme_config = function (plugin)
    if type(plugin.setup) == "function" then
      plugin.setup({})
    end
  end
}

return {
  System = System,
  Themes = Themes,
}
