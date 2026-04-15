local filter = Vkz.vkzlib.Data.list.filter
local elem = Vkz.vkzlib.Data.list.elem
local merge_plugin_opts = require("profiles.utils").merge_plugin_opts

local opts = {

	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	indent = {
		enable = true,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<C-Space>",
			node_incremental = "<C-Space>",
			scope_incremental = false,
			node_decremental = "<BS>",
		},
	},
	textobjects = {
		move = {
			enable = true,
			goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
			goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
			goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
			goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
		},
	},
}

---@type LazyPluginSpec
return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	opts = merge_plugin_opts(Vkz.vkzlib.io.lua.get_caller_module_path(), opts),
	init = function()
		local treesitter = require("nvim-treesitter")

		-- Enable highlight and indentation
		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				pcall(vim.treesitter.start)
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})

		-- Install required parsers
		local ensure_installed = {
			-- CLI
			"bash",
			"powershell",
			-- Text
			"markdown",
			"markdown_inline",
			"latex",
			"todotxt",
			-- Docs
			"comment",
			"doxygen",
			"jsdoc",
			"luadoc",
			-- Data
			"csv",
			"psv",
			"tsv",
			"json",
			"http",
			-- Git
			"git_config",
			"git_rebase",
			"gitattributes",
			"gitcommit",
			"gitignore",
			-- Configuration
			"make",
			"cmake",
			"dockerfile",
			"ini",
			"meson",
			"nginx",
			"ninja",
			"requirements",
			"toml",
			"xml",
			"yaml",
			-- Vim
			"vim",
			"vimdoc",
			"query",
			-- Pattern
			"regex",

			-- Languages

			-- Assembly
			"asm",
			-- SQL
			"sql",
			-- C Family
			"c",
			"objc",
			"cpp",
			"c_sharp",
			"llvm",
			"printf",
			-- Haskell
			"haskell",
			"haskell_persistent",
			-- JVM
			"java",
			"kotlin",
			-- Rust
			"rust",
			-- Lua
			"lua",
			"luap",
			"luau",
			-- Python
			"python",
			-- Web
			"html",
			"css",
			"javascript",
			"scss",
			"typescript",
			"tsx",
			"vue",
		}
		local installed = treesitter.get_installed()
		treesitter.install(filter(function(x)
			return not elem(x, installed)
		end, ensure_installed))
	end,
}
