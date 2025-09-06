local profile = require("profiles")

---@type LazyPluginSpec
return {
	"L3MON4D3/LuaSnip",
  dependencies = { "rafamadriz/friendly-snippets" },
  lazy = true,
	-- install jsregexp (optional!).
  -- NOTE: Call this manually if failed
	build = profile.preference.cc and "make install_jsregexp CC=" .. profile.preference.cc or "make install_jsregexp",
  config = function ()
    require("luasnip").filetype_extend("typescript", { "javascript" })
    require("luasnip.loaders.from_vscode").lazy_load()
  end,
}
