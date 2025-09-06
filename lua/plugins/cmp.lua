local merge_plugin_opts = require("profiles.utils").merge_plugin_opts
local deep_merge = Vkz.vkzlib.Data.table.deep_merge

---@param fallback fun()
local function select_next_item(fallback)
	local cmp = require("cmp")
	local luasnip = require("luasnip")
	if cmp.visible() then
		cmp.select_next_item()
	elseif luasnip.locally_jumpable(1) then
		luasnip.jump(1)
	else
		fallback()
	end
end

---@param fallback fun()
local function select_prev_item(fallback)
	local cmp = require("cmp")
	local luasnip = require("luasnip")
	if cmp.visible() then
		cmp.select_prev_item()
	elseif luasnip.locally_jumpable(-1) then
		luasnip.jump(-1)
	else
		fallback()
	end
end

---@param fallback fun()
local function confirm(fallback)
	local cmp = require("cmp")
	local luasnip = require("luasnip")
	if cmp.visible() then
		if luasnip.expandable() then
			luasnip.expand({})
		else
			cmp.confirm({
				select = true,
			})
		end
	else
		fallback()
	end
end

-- stylua: ignore start
local kind_icons = {
  ["Class"]         = "",
  ["Color"]         = "",
  ["Constant"]      = "",
  ["Constructor"]   = "",
  ["Enum"]          = "",
  ["EnumMember"]    = "",
  ["Event"]         = "",
  ["Field"]         = "",
  ["File"]          = "",
  ["Folder"]        = "",
  ["Function"]      = "",
  ["Interface"]     = "",
  ["Keyword"]       = "",
  ["Method"]        = "",
  ["Module"]        = "",
  ["Operator"]      = "",
  ["Property"]      = "",
  ["Reference"]     = "",
  ["Snippet"]       = "",
  ["Struct"]        = "",
  ["Text"]          = "",
  ["TypeParameter"] = "",
  ["Unit"]          = "",
  ["Value"]         = "",
  ["Variable"]      = "",

  -- crates.nvim extensions
  ["Version"]       = "",
  ["Feature"]       = "",
}

local source_names = {
  nvim_lsp = "LSP",
  git = "Git",
  lazydev = "LazyDev",
  luasnip = "LuaSnip",
  buffer = "Buffer",
  path = "Path",
  cmdline = "CMD",
}
-- stylua: ignore end

---@class plugins.cmp.Extras
local extras = {
	select_next_item = select_next_item,
	select_prev_item = select_prev_item,
	confirm = confirm,
}

local opts = function(_, o)
	local cmp = require("cmp")
	local cmp_under_comparator = require("cmp-under-comparator")
	local luasnip = function ()
    return require("luasnip")
  end
	return deep_merge("force", o, {
		snippet = {
			expand = function(args)
				luasnip().lsp_expand(args.body) -- For `luasnip` users.
				-- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
			end,
		},

		window = {
			-- completion = cmp.config.window.bordered(),
			documentation = cmp.config.window.bordered(),
		},

		formatting = {
			fields = { "abbr", "kind", "menu" },
      ---@param entry cmp.Entry
      ---@param vim_item vim.CompletedItem
      ---@return vim.CompletedItem
			format = function(entry, vim_item)
        local abbr = vim_item.abbr
        local source = entry.source.name
        source = source_names[source] or source
				local kind = vim_item.kind or "Unknown"
        local icon = kind_icons[kind] or " "
        vim_item.abbr = string.format("%s %s", icon, abbr)
        vim_item.kind = string.format("(%s)", kind)
        vim_item.menu = string.format("[%s]", source)
        if kind ~= "Unknown" then
          vim_item.abbr_hl_group = "CmpItemKind" .. kind
        end
				return vim_item
			end,
		},

		mapping = cmp.mapping.preset.insert({
			["<CR>"] = cmp.mapping(confirm, { "i", "s" }),
			["<Down>"] = cmp.mapping(select_next_item, { "i", "s" }),
			["<C-n>"] = cmp.mapping(select_next_item, { "i", "s" }),
			["<Up>"] = cmp.mapping(select_prev_item, { "i", "s" }),
			["<C-p>"] = cmp.mapping(select_prev_item, { "i", "s" }),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-b>"] = cmp.mapping.scroll_docs(-4),
			["<C-r>"] = cmp.mapping.abort(),
		}),

		sources = cmp.config.sources(
			{
				{ name = "nvim_lsp" },
				-- { name = "nvim_lua" },
				{ name = "luasnip" }, -- For luasnip users.
				-- { name = "orgmode" },
				{ name = "render-markdown" },
			},
			{
				{ name = "buffer" },
			},
			-- Lazydev completion source for require statements and module annotations
			{
				name = "lazydev",
				group_index = 0, -- set group index to 0 to skip loading LuaLS completions
			}
		),

		---@diagnostic disable-next-line: missing-fields
		sorting = {
			comparators = {
				cmp.config.compare.offset,
				cmp.config.compare.exact,
				cmp.config.compare.score,
				cmp_under_comparator.under,
				cmp.config.compare.kind,
				cmp.config.compare.sort_text,
				cmp.config.compare.length,
				cmp.config.compare.order,
			},
		},
	})
end

---@type LazyPluginSpec
return {
	"hrsh7th/nvim-cmp",
	event = { "InsertEnter", "CmdlineEnter" },
	dependencies = {
		"neovim/nvim-lspconfig",
		"L3MON4D3/LuaSnip",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"lukas-reineke/cmp-under-comparator",
		"petertriho/cmp-git",
		"saadparwaiz1/cmp_luasnip",
	},
	init = function()
		vim.opt.completeopt = { "menu", "menuone", "noselect" }
	end,
	opts = merge_plugin_opts(Vkz.vkzlib.io.lua.get_caller_module_path(), opts, extras),
	config = function(_, o)
		local cmp = require("cmp")

		cmp.setup(o)

		cmp.setup.filetype("gitcommit", {
			sources = cmp.config.sources({
				{ name = "git" },
			}, {
				{ name = "buffer" },
			}),
		})

		cmp.setup.cmdline({ "/", "?" }, {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},
		})

		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{ name = "cmdline" },
			}),
			---@diagnostic disable-next-line: missing-fields
			matching = { disallow_symbol_nonprefix_matching = false },
		})
	end,
}
