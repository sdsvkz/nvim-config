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
--]]

---@module "lint"
---@module "conform"

local toolsConfig = require("profiles.utils").toolsConfig
local vkzlib = Vkz.vkzlib

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

		---Enables mouse support
		---@see vim.o.mouse
		---
		---@type string
		mouse = "niv",

		---@type boolean
		enable_discord_rich_presence = false,

		---Setup required flags here
		---This will only be called if using Neovide
		---@type fun()?
		config_neovide = nil,
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
		---@class profiles.Profile.Appearence.Theme
		---`profiles.options.Themes` included some presets
		---Default is equivalent to `theme = options.Themes.moonfly`
		--- NOTE: Better override this field to change colorscheme instead of using vim command
		theme = {
			---To get list of available themes
			---Run `:lua for _, theme in ipairs(vim.fn.getcompletion("", "color")) do print(theme) end`
			--- NOTE: This only show loaded themes at this point
			---
			---@type string
			colorscheme = "moonfly",

			---Configure theme here
			---e.g. Calling `plugin.setup`, set vim.g
			---
			---@type (fun(plugin: table, opts: table, spec: LazyPlugin) | true)?
			theme_config = nil,

			--- Pass theme module name `main` to get `config` function for `LazyPluginSpec`
			--- or other valid values for `config`
			---
			---@type ((fun(main: string): fun(self: LazyPlugin, opts: table)) | true)?
			config = nil,
		},

		---Put startup menus into "lua/config/menu"
		---Choose here using module name
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
			[{ "c", "cpp" }] = {
				---Whether to use this language
				---e.g. You can use this to implement platform
				---@type boolean?
				enable = false,
				---@class profiles.Profile.Languages.Tools
				tools = {
					-- TEST: Add `conform` supported options to `formatters`

					-- NOTE: To make formatters and linters work, install required tools (using Mason)
					-- If Mason enabled, language servers will be automatically installed (by mason-tool-installer)

					---Formatters of this filetype
					---@type conform.FiletypeFormatter?
					formatters = nil,
					-- Linters of this filetype
					---@type (string | config.lint.LinterSpec)[]?
					linters = nil,
					---Map of language server name to configuration
					---Use names from lspconfig, not mason
					---@type { [config.lsp.Server.MasonConfig]: config.lsp.Handler }?
					ls = {
						[toolsConfig.clangd.masonConfig] = true,
					},
					-- TODO: Add dap config here after nvim-dap is added
				},
			},
      ---@type profiles.Profile.Languages.Language
			cmake = {
        enable = false,
        ---@type profiles.Profile.Languages.Tools
				tools = {
          ---@type { [config.lsp.Server.MasonConfig]: config.lsp.Handler }?
					ls = {
						[toolsConfig.neocmake.masonConfig] = toolsConfig.neocmake.handler,
					},
				},
			},
      ---@type profiles.Profile.Languages.Language
			haskell = {
        enable = false,
        ---@type profiles.Profile.Languages.Tools
				tools = {
					-- formatters = { "ormolu" }, -- HLS use Ormolu as built-in formatter

          ---@type (string | config.lint.LinterSpec)[]?
					linters = { "hlint" },
					-- NOTE: This require Haskell Language Server in PATH
					-- `haskell-tools.nvim` will handle setup
					-- I recommend using GHCup to install HLS so that you can pick the one support your GHC version
					--
					-- ls = {
					--   ["hls"] = {
					--     -- Use HLS from PATH for better customization
					--     -- Since only supported ghc versions can be used
					--     config = true
					--   },
					-- },
				},
			},
      -- NOTE: Enabled by default
      ---@type profiles.Profile.Languages.Language
			json = {
        enable = true,
				---@type profiles.Profile.Languages.Tools
				tools = {
					---@type { [config.lsp.Server.MasonConfig]: config.lsp.Handler }?
					ls = {
						[toolsConfig.jsonls.masonConfig] = toolsConfig.jsonls.handler,
          },
				},
			},
      -- NOTE: Enabled by default
      ---@type profiles.Profile.Languages.Language
			lua = {
        enable = true,
        ---@type profiles.Profile.Languages.Tools
				tools = {
          ---@type conform.FiletypeFormatter?
					formatters = { "stylua" },
					---@type (string | config.lint.LinterSpec)[]?
					linters = {
						toolsConfig.luacheck,
					},
          ---@type { [config.lsp.Server.MasonConfig]: config.lsp.Handler }?
					ls = {
						[toolsConfig.lua_ls.masonConfig] = toolsConfig.lua_ls.handler,
					},
				},
			},
      ---@type profiles.Profile.Languages.Language
			markdown = {
        enable = false,
        ---@type profiles.Profile.Languages.Tools
				tools = {
          ---@type conform.FiletypeFormatter?
					formatters = { "prettier" },
				},
			},
      ---@type profiles.Profile.Languages.Language
			ps1 = {
        enable = false,
        ---@type profiles.Profile.Languages.Tools
				tools = {
          ---@type { [config.lsp.Server.MasonConfig]: config.lsp.Handler }?
					ls = {
						[toolsConfig.powershell_es.masonConfig] = toolsConfig.powershell_es.handler,
					},
				},
			},
      ---@type profiles.Profile.Languages.Language
			python = {
        enable = false,
        ---@type profiles.Profile.Languages.Tools
				tools = {
          ---@type conform.FiletypeFormatter?
					formatters = { "isort", "black" },
          ---@type (string | config.lint.LinterSpec)[]?
					linters = { "flake8", "bandit" },
          ---@type { [config.lsp.Server.MasonConfig]: config.lsp.Handler }?
					ls = {
						[toolsConfig.pyright.masonConfig] = true,
					},
				},
			},
      ---@type profiles.Profile.Languages.Language
			[{ "bash", "sh" }] = {
        enable = false,
        ---@type profiles.Profile.Languages.Tools
				tools = {
          ---@type conform.FiletypeFormatter?
					formatters = { "shfmt" },
          ---@type (string | config.lint.LinterSpec)[]?
					linters = { "shellcheck" },
          ---@type { [config.lsp.Server.MasonConfig]: config.lsp.Handler }?
					ls = {
						[toolsConfig.bashls.masonConfig] = true,
					},
				},
			},
      ---@type profiles.Profile.Languages.Language
			rust = {
        enable = false,
        ---@type profiles.Profile.Languages.Tools
				tools = {
					-- NOTE: This require `rust-analyzer` in PATH
					-- `rustaceanvim` will handle setup.
					-- rustaceanvim won't use rust-analyzer installed by mason without any additional configuration.
					-- So you have to install it manually
					-- The main reason for this choice is that it mason.nvim installations of rust-analyzer
					-- will most likely have been built with a different toolchain than your project,
					-- leading to inconsistencies and possibly subtle bugs.
					--
					-- ls = {
					--   ["rust_analyzer"] = false,
					-- }
				},
			},
      -- NOTE: Enabled by default
      ---@type profiles.Profile.Languages.Language
			yaml = {
        enable = true,
        ---@type profiles.Profile.Languages.Tools
				tools = {
          ---@type conform.FiletypeFormatter?
					formatters = { "prettier" },
          ---@type (string | config.lint.LinterSpec)[]?
					linters = { "yamllint" },
          ---@type { [config.lsp.Server.MasonConfig]: config.lsp.Handler }?
					ls = {
						[toolsConfig.yamlls.masonConfig] = toolsConfig.yamlls.handler,
					},
				},
			},
		},

		---Map filetype into language options
		---Override this in your own profile. It will be merged with `supported`
		---@type table<string | string[], profiles.Profile.Languages.Language>
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
			-- -- Load default using `local default = require("profiles.default")`
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
		---@type table<string, conform.FiletypeFormatter>?
		formatters = nil,

		---This should be extracted automatically from fields above
		---@type table<string, (string | config.lint.LinterSpec)[]>?
		linters = nil,

		---This should be extracted automatically from fields above
		---@type { [config.lsp.Server.MasonConfig]: config.lsp.Handler }?
		ls = nil,
	},

	---Debugging
	---@class profiles.Profile.Debugging
	debugging = {},

	---Name of profile
	---use module name if not overrided
	---@type string
	name = "Default",

	-- This field will be injected in profile.init

	---Utils for profile
	---@module "profiles.utils"
	utils = {},
}

return profile
