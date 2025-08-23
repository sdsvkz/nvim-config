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

---@alias profiles.Profile.Default.Name "Default"
---@type profiles.Profile.Default.Name
local NAME = "Default"
local toolsConfig = require("profiles.utils").toolsConfig

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

		---@type fun(): LazyConfig
		lazy_opts = function()
			---@type LazyConfig
			return {
				spec = {
					-- import your plugins
					{ import = "plugins" },
				},
				-- Configure any other settings here. See the documentation for more details.
				-- colorscheme that will be used when installing plugins.
				install = { colorscheme = { "habamax" } },
				-- automatically check for plugin updates
				checker = { enabled = true },
			}
		end,
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

					---@alias profiles.Profile.Languages.Tools.Formatters conform.FiletypeFormatter
					---@alias profiles.Profile.Languages.Tools.Linters (string | config.lint.LinterSpec)[]
					---@alias profiles.Profile.Languages.Tools.LanguageServers table<config.mason.InstallConfig, config.lsp.Handler>

					---Formatters of this filetype
					---@type profiles.Profile.Languages.Tools.Formatters?
					formatters = nil,
					---Linters of this filetype
					---@type profiles.Profile.Languages.Tools.Linters?
					linters = nil,
					---Map of language server name to configuration
					---Use names from lspconfig, not mason
					---@type profiles.Profile.Languages.Tools.LanguageServers?
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
					---@type profiles.Profile.Languages.Tools.LanguageServers?
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

					---@type profiles.Profile.Languages.Tools.Linters?
					linters = { { "hlint", auto_update = true } },
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
					---@type profiles.Profile.Languages.Tools.LanguageServers?
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
					---@type profiles.Profile.Languages.Tools.Formatters?
					formatters = { "stylua" },
					---@type profiles.Profile.Languages.Tools.Linters?
					linters = {
						toolsConfig.luacheck,
					},
					---@type profiles.Profile.Languages.Tools.LanguageServers?
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
					---@type profiles.Profile.Languages.Tools.Formatters?
					formatters = { "prettier" },
				},
			},
			---@type profiles.Profile.Languages.Language
			ps1 = {
				enable = false,
				---@type profiles.Profile.Languages.Tools
				tools = {
					---@type profiles.Profile.Languages.Tools.LanguageServers?
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
					---@type profiles.Profile.Languages.Tools.Formatters?
					formatters = { "isort", "black" },
					---@type profiles.Profile.Languages.Tools.Linters?
					linters = {
						{ "flake8", auto_update = true },
						{ "bandit", auto_update = true },
					},
					---@type profiles.Profile.Languages.Tools.LanguageServers?
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
					---@type profiles.Profile.Languages.Tools.Formatters?
					formatters = { "shfmt" },
					---@type profiles.Profile.Languages.Tools.Linters?
					linters = {
						{ "shellcheck", auto_update = true },
					},
					---@type profiles.Profile.Languages.Tools.LanguageServers?
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
			---@type profiles.Profile.Languages.Language
			[{ "typescript", "javascript" }] = {
        -- NOTE: You still need to setup ESLint in your project
        -- See https://eslint.org/docs/latest/use/getting-started#quick-start
				enable = true,
				---@type profiles.Profile.Languages.Tools
				tools = {
					formatters = { "prettier" },
					---@type profiles.Profile.Languages.Tools.LanguageServers
					ls = {
						[toolsConfig.vtsls.masonConfig] = toolsConfig.vtsls.handler,
						[toolsConfig.eslint.masonConfig] = toolsConfig.eslint.handler,
					},
				},
			},
			-- NOTE: Enabled by default
			---@type profiles.Profile.Languages.Language
			yaml = {
				enable = true,
				---@type profiles.Profile.Languages.Tools
				tools = {
					---@type profiles.Profile.Languages.Tools.Formatters?
					formatters = { "prettier" },
					---@type profiles.Profile.Languages.Tools.Linters?
					linters = {
						{ "yamllint", auto_update = true },
					},
					---@type profiles.Profile.Languages.Tools.LanguageServers?
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
		---@type table<string, profiles.Profile.Languages.Tools.Formatters>?
		formatters = nil,

		---This should be extracted automatically from fields above
		---@type table<string, profiles.Profile.Languages.Tools.Linters>?
		linters = nil,

		---This should be extracted automatically from fields above
		---@type profiles.Profile.Languages.Tools.LanguageServers?
		ls = nil,
	},

	---Debugging
	---@class profiles.Profile.Debugging
	debugging = {
		---@type vim.log.levels
		log_level = vim.log.levels.INFO,
	},

	---Name of profile
	---use module name if not overrided
	---@type string
	name = NAME,

	-- This field will be injected in profile.init

	---Utils for profile
	---@module "profiles.utils"
	utils = {},
}

return profile
