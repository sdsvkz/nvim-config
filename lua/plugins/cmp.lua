return {
	"hrsh7th/nvim-cmp",
	event = { "InsertEnter", "CmdlineEnter" },
	dependencies = {
		require("plugins.lspconfig"),
		require("plugins.luaSnip"),
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"lukas-reineke/cmp-under-comparator",
		{ "petertriho/cmp-git", dependencies = { require("plugins.libs.plenary") }, opts = {} },
		"saadparwaiz1/cmp_luasnip",
	},
	init = function()
		vim.opt.completeopt = { "menu", "menuone", "noselect" }
	end,
	config = function()
		local cmp = require("cmp")
		local cmp_under_comparator = require("cmp-under-comparator")
		local luasnip = require("luasnip")

		local function select_next_item(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.locally_jumpable(1) then
				luasnip.jump(1)
			else
				fallback()
			end
		end

		local function select_prev_item(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end

		local function confirm(fallback)
			if cmp.visible() then
				-- if luasnip.expandable() then
				-- 	luasnip.expand({})
				-- else
				cmp.confirm({
					select = true,
				})
				-- end
			else
				fallback()
			end
		end

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body) -- For `luasnip` users.
          vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
				end,
			},

			window = {
				-- completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},

			mapping = cmp.mapping.preset.insert({
				["<CR>"] = cmp.mapping(confirm, { "i", "s" }),
				["<Down>"] = cmp.mapping(select_next_item, { "i", "s" }),
				["<C-n>"] = cmp.mapping(select_next_item, { "i", "s" }),
				["<Up>"] = cmp.mapping(select_prev_item, { "i", "s" }),
				["<C-p>"] = cmp.mapping(select_prev_item, { "i", "s" }),
        -- BUG: Scrool Docs doesn't work
				["C-f"] = cmp.mapping.scroll_docs(4),
				["C-b"] = cmp.mapping.scroll_docs(-4),
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

		cmp.setup.filetype("gitcommit", {
			sources = cmp.config.sources({
				{ name = "git" },
			}, {
				{ name = "buffer" },
			}),
		})
		require("cmp_git").setup({})

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
