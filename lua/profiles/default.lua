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
		---`options.Themes` included some default setup
		---This equivalent to `theme = options.Themes.moonfly`
		--- NOTE: Better override this field to change colorscheme instead of using vim command
		---
		---@see Themes
		theme = {
			---To get list of available themes
			---Run `:lua for _, theme in ipairs(vim.fn.getcompletion("", "color")) do print(theme) end`
			--- NOTE: This only show loaded themes at this point
			---
			---@type string
			colorscheme = "habamax",

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
				enable = nil,
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
						[{ "clangd", auto_update = true }] = true,
					},
					-- TODO: Add dap config here after nvim-dap is added
				},
			},
			cmake = {
				tools = {
					-- linters = { "cmakelint" },
					ls = {
						[{ "neocmake", auto_update = true }] = function()
							vim.lsp.config("neocmake", {
								init_options = {
									-- Annoying
									lint = {
										enable = false,
									},
								},
							})
              vim.lsp.enable("neocmake")
						end,
					},
				},
			},
			haskell = {
				tools = {
					-- formatters = { "ormolu" }, -- HLS use Ormolu as built-in formatter
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
			json = {
				-- TODO: Enable json by default
				---@type profiles.Profile.Languages.Tools
				tools = {
					---@type { [config.lsp.Server.MasonConfig]: config.lsp.Handler }?
					ls = {
						[{ "jsonls", auto_update = true }] = function()
							vim.lsp.config("jsonls", {
								settings = {
									json = {
										format = {
											enable = true,
										},
										schemas = vkzlib.data.list.concat(require("schemastore").json.schemas({
											extra = {
												{
													description = "Lua language server configuration file",
													fileMatch = { ".luarc.json" },
													name = ".luarc.json",
													url = "https://raw.githubusercontent.com/sumneko/vscode-lua/master/setting/schema.json",
												},
											},
										})),
										validate = { enable = true },
									},
								},
							})
              vim.lsp.enable("jsonls")
						end,
					},
				},
			},
			lua = {
				-- TODO: Enable lua by default
				tools = {
					formatters = { "stylua" },
					---@type (string | config.lint.LinterSpec)[]?
					linters = {
						{
							"luacheck",
							opts = function(linter)
								---@type lint.Linter
								---@diagnostic disable-next-line: missing-fields
								local properties = {
									args = {
										-- Ignore some warnings, see https://luacheck.readthedocs.io/en/stable/warnings.html
										-- Some of them are duplicated with `luals`, others are annoying
										"--ignore",
										"21*",
										"611",
										"612",
										"631",
										vkzlib.data.list.unpack(linter.args),
									},
								}
								return vkzlib.data.table.deep_merge("force", linter, properties)
							end,
						},
					},
					ls = {
						[{ "lua_ls", auto_update = true }] = function()
							vim.lsp.config("lua_ls", {
								on_init = function(client)
									local path = client.workspace_folders[1].name
									---@diagnostic disable-next-line: undefined-field
									if
										---@diagnostic disable-next-line: undefined-field
										vim.uv.fs_stat(path .. "/.luarc.json")
										---@diagnostic disable-next-line: undefined-field
										or vim.uv.fs_stat(path .. "/.luarc.jsonc")
									then
										return
									end

									client.config.settings.Lua =
										vim.tbl_deep_extend("force", client.config.settings.Lua, {
											runtime = {
												-- Tell the language server which version of Lua you're using
												-- (most likely LuaJIT in the case of Neovim)
												version = "LuaJIT",
											},
											-- Make the server aware of Neovim runtime files
											workspace = {
												checkThirdParty = false,
												library = {
													vim.env.VIMRUNTIME,
													-- Depending on the usage, you might want to add additional paths here.
													-- "${3rd}/luv/library"
													-- "${3rd}/busted/library",
												},
												-- or pull in all of 'runtimepath'.
												-- library = vim.api.nvim_get_runtime_file("", true)
											},
										})
								end,

								settings = {
									Lua = {},
								},
							})
              vim.lsp.enable("lua_ls")
						end,
					},
				},
			},
			markdown = {
				tools = {
					formatters = { "prettier" },
					linters = { "markdownlint-cli2" },
				},
			},
			ps1 = {
				tools = {
					ls = {
						[{ "powershell_es", auto_update = true }] = function()
							vim.lsp.config("powershell_es", {
								bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
								init_options = {
									enableProfileLoading = false,
								},
							})
              vim.lsp.enable("powershell_es")
						end,
					},
				},
			},
			python = {
				tools = {
					formatters = { "isort", "black" },
					linters = { "flake8", "bandit" },
					ls = {
						[{ "pyright", auto_update = true }] = true,
					},
				},
			},
			[{ "bash", "sh" }] = {
				tools = {
					formatters = { "shfmt" },
					linters = { "shellcheck" },
					ls = {
						[{ "bashls", auto_update = true }] = true,
					},
				},
			},
			rust = {
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
			yaml = {
				-- TODO: Enable yaml by default
				tools = {
					formatters = { "prettier" },
					linters = { "yamllint" },
					ls = {
						[{ "yamlls", auto_update = true }] = function()
							vim.lsp.config("yamlls", {
								settings = {
									yaml = {
										format = {
											enable = true,
										},
										validate = true,
                    schemas = require('schemastore').yaml.schemas(),
										schemaStore = {
											-- Must disable built-in schemaStore support to use
											-- schemas from SchemaStore.nvim plugin
											enable = false,
											-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
											url = "",
										},
									},
								},
							})
              vim.lsp.enable("yamlls")
						end,
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
