---@enum Profiles.Options.System
local System = {
  Windows = "Windows_NT",
  Linux = "Linux",
  -- MacOS = "Darwin",
}

---@type table<string, profiles.Profile.Appearence.Theme>
local Themes = {}

Themes.catppuccin = {
  colorscheme = "catppuccin",
}

---@diagnostic disable-next-line: inject-field
Themes.catppuccin.integration = {
  alpha = true,
  -- barbecue = { dim_dirname = true, bold_basename = true, dim_context = false, alt_background = false },
  cmp = true,
  dap = true,
  dap_ui = true,
  gitsigns = true,
  -- hop = true,
  illuminate = {
    enabled = true,
    lsp = true
  },
  indent_blankline = {
    enabled = true,
    scope_color = "", -- catppuccin color (eg. `lavender`) Default: text
    colored_indent_levels = false,
  },
  lsp_saga = true,
  lsp_trouble = true,
  markdown = true,
  mason = true,
  mini = {
    enabled = true,
    indentscope_color = "",
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
}

Themes.catppuccin.theme_config = function (plugin)
  if type(plugin.setup) == "function" then
    plugin.setup({ integration = Themes.catppuccin.integration })
  end
end

Themes.fluoromachine = {
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
  colorscheme = "moonfly",
}

Themes.nightowl = {
  colorscheme = "night-owl",
  theme_config = function (plugin)
    if type(plugin.setup) == "function" then
      plugin.setup({})
    end
  end
}

Themes.tokyonight = {
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
