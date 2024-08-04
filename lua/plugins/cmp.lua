local cmp_main = {
	"hrsh7th/nvim-cmp",
	dependencies = {
    require('plugins.lspconfig'),
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"saadparwaiz1/cmp_luasnip",
		require('plugins.luaSnip'),
	},
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
	  vim.opt.completeopt = { "menu", "menuone", "noselect" }

	  cmp.setup({
		  snippet = {
			  expand = function(args)
				  luasnip.lsp_expand(args.body) -- For `luasnip` users.
			  end,
		  },

		  window = {
			  -- completion = cmp.config.window.bordered(),
			  -- documentation = cmp.config.window.bordered(),
		  },

		  mapping = cmp.mapping.preset.insert({

			  ['<CR>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            if luasnip.expandable() then
              luasnip.expand()
            else
              cmp.confirm({
                select = true,
              })
            end
          else
            fallback()
          end
        end),

        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.locally_jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
		  }),

		  sources = cmp.config.sources({
			  { name = "nvim_lsp" },
			  { name = "nvim_lua" },
			  { name = "luasnip" }, -- For luasnip users.
        -- { name = "orgmode" },
		  },
      {
			  { name = "buffer" },
			  { name = "path" },
		  }),

      sorting = {
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          require("cmp-under-comparator").under,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },

	  })

    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      }
    })

	  cmp.setup.cmdline(":", {
		  mapping = cmp.mapping.preset.cmdline(),
		  sources = cmp.config.sources({
			  { name = "path" },
		  },
      {
			  { name = "cmdline" },
		  }),
	  })

  end

}

local cmp_under_comparator = {
  "lukas-reineke/cmp-under-comparator"
}

return {
  cmp_main,
  cmp_under_comparator
}
