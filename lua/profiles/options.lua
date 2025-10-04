local concat = Vkz.vkzlib.Data.list.concat
local deep_merge = Vkz.vkzlib.Data.table.deep_merge

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
		dap = true,
		dap_ui = true,
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

Themes.catppuccin.theme_config = function(plugin)
	if type(plugin.setup) == "function" then
		plugin.setup(Themes.catppuccin.opts)
	end
end

Themes.fluoromachine = {
	plugin = "fluoromachine",
	colorscheme = "fluoromachine",
	theme_config = function(plugin)
		if type(plugin.setup) == "function" then
			plugin.setup({
				glow = true,
				theme = "fluoromachine",
			})
		end
	end,
}

Themes.moonfly = {
	plugin = "fluoromachine",
	colorscheme = "moonfly",
}

Themes.nightowl = {
	plugin = "night_owl",
	colorscheme = "night-owl",
	theme_config = function(plugin)
		if type(plugin.setup) == "function" then
			plugin.setup({})
		end
	end,
}

Themes.tokyonight = {
	plugin = "tokyonight",
	colorscheme = "tokyonight",
	theme_config = function(plugin)
		if type(plugin.setup) == "function" then
			plugin.setup({})
		end
	end,
}

---@module "lint"
---@module "conform"
---@module "dap"

local ToolConfigs = {
	angularls = {
		masonConfig = { "angularls", auto_update = true },
		handler = function()
			vim.lsp.config("angularls", {
				root_dir = function(bufnr, on_dir)
					local fname = vim.api.nvim_buf_get_name(bufnr)
					-- Look for angular.json as the project root
					local root = require("lspconfig.util").root_pattern("angular.json")(fname)
					if root then
						on_dir(root)
					end
				end,
			})
			vim.lsp.enable("angularls")
		end,
	},
	bashls = {
		masonConfig = { "bashls", auto_update = true },
	},
	clangd = {
		masonConfig = { "clangd", auto_update = true },
	},
	codelldb = {
		masonConfig = { "codelldb", auto_update = true },
		---@type dap.Adapter | dap.AdapterFactory
		adapter = {
			type = "executable",
			command = "codelldb",
			detached = vim.uv.os_uname().sysname ~= System.Windows,
		},
		---@type profiles.Profile.Languages.Tools.Dap.Configurations
		configurations = {
			{
				{
					name = "Launch file",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
			},
		},
	},
	---@typ
	eslint = {
		masonConfig = { "eslint", auto_update = true },
		-- Format on save
		handler = function()
			local base_on_attach = vim.lsp.config.eslint.on_attach
			vim.lsp.config("eslint", {
				on_attach = function(client, bufnr)
					if not base_on_attach then
						return
					end

					base_on_attach(client, bufnr)
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						command = "LspEslintFixAll",
					})
				end,
			})

			-- --- Filter out diagnostics from `vtsls`
			-- local default_handler = vim.lsp.handlers["textDocument/publishDiagnostics"]
			-- vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
			-- 	if result and result.diagnostics then
			-- 		result.diagnostics = vim.tbl_filter(function(diagnostic)
			-- 			return diagnostic.source ~= "ts"
			-- 		end, result.diagnostics)
			-- 	end
			-- 	return default_handler(err, result, ctx, config)
			-- end

			vim.lsp.enable("eslint")
		end,
	},
	---@type config.lint.LinterSpec
	luacheck = {
		"luacheck",
		auto_update = true,
		-- -- Example on disable auto-installation
		-- condition = function ()
		--   return false
		-- end,
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
					unpack(linter.args),
				},
			}
			return deep_merge("force", linter, properties)
		end,
	},
	lua_ls = {
		masonConfig = { "lua_ls", auto_update = true },
		handler = function()
			vim.lsp.config("lua_ls", {
				on_init = function(client)
					if client.workspace_folders then
						local path = client.workspace_folders[1].name
						local config_path = vim.fn.stdpath("config")
						if path ~= config_path and path ~= config_path:gsub("\\", "/") then
							return
						end
					end

					client.config.settings.Lua = deep_merge("force", client.config.settings.Lua, {
						runtime = {
							-- Tell the language server which version of Lua you're using
							-- (most likely LuaJIT in the case of Neovim)
							version = "LuaJIT",
							-- Tell the language server how to find Lua modules same way as Neovim
							-- (see `:h lua-module-load`)
							path = {
								"lua/?.lua",
								"lua/?/init.lua",
								"/lua/libs/?.lua",
								"/lua/libs/?/init.lua",
							},
						},
						-- Make the server aware of Neovim runtime files
						workspace = {
							checkThirdParty = false,
							library = {
								vim.env.VIMRUNTIME,
								vim.fn.stdpath("config") .. "/lua",
								vim.fn.stdpath("config") .. "/lua/libs",
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
					Lua = {
						hint = {
							enable = true,
							-- setType = true,
						},
					},
				},
			})
			vim.lsp.enable("lua_ls")
		end,
	},
	jsonls = {
		masonConfig = { "jsonls", auto_update = true },
		handler = function()
			vim.lsp.config("jsonls", {
				settings = {
					json = {
						format = {
							enable = true,
						},
						schemas = concat(require("schemastore").json.schemas({
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
	neocmake = {
		masonConfig = { "neocmake", auto_update = true },
		handler = function()
			vim.lsp.config("neocmake", {
				single_file_support = true,
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
	powershell_es = {
		masonConfig = { "powershell_es", auto_update = true },
		handler = function()
			vim.lsp.config("powershell_es", {
				bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
				init_options = {
					enableProfileLoading = false,
				},
			})
			vim.lsp.enable("powershell_es")
		end,
	},
	pyright = {
		masonConfig = { "pyright", auto_update = true },
	},
	vtsls = {
		masonConfig = { "vtsls", auto_update = true },
		handler = function()
			vim.lsp.config("vtsls", {
				filetypes = {
					"javascript",
					"javascriptreact",
					"javascript.jsx",
					"typescript",
					"typescriptreact",
					"typescript.tsx",
				},
				settings = {
					complete_function_calls = false,
					vtsls = {
						enableMoveToFileCodeAction = true,
						autoUseWorkspaceTsdk = true,
						experimental = {
							maxInlayHintLength = 50,
							completion = {
								enableServerSideFuzzyMatch = true,
							},
						},
					},
					javascript = {
						updateImportsOnFileMove = { enabled = "always" },
						suggest = {
							completeFunctionCalls = false,
						},
						inlayHints = {
							functionLikeReturnTypes = { enabled = true },
							parameterNames = { enabled = "literals" },
							parameterTypes = { enabled = true },
							propertyDeclarationTypes = { enabled = true },
							variableTypes = { enabled = false },
						},
					},
					typescript = {
						updateImportsOnFileMove = { enabled = "always" },
						suggest = {
							completeFunctionCalls = false,
						},
						inlayHints = {
							enumMemberValues = { enabled = true },
							functionLikeReturnTypes = { enabled = true },
							parameterNames = { enabled = "literals" },
							parameterTypes = { enabled = true },
							propertyDeclarationTypes = { enabled = true },
							variableTypes = { enabled = false },
						},
					},
				},
			})
		end,
		vim.lsp.enable("vtsls"),
	},
	yamlls = {
		masonConfig = { "yamlls", auto_update = true },
		handler = function()
			vim.lsp.config("yamlls", {
				settings = {
					yaml = {
						format = {
							enable = true,
						},
						validate = true,
						schemas = require("schemastore").yaml.schemas(),
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
}

local NeotestAdapters = {
	gtest = {
		spec = "alfaix/neotest-gtest",
		adapter = function()
			local gtest = require("neotest-gtest").setup({})
			return {
				gtest,
			}
		end,
	},
}

return {
	System = System,
	Themes = Themes,
	ToolConfigs = ToolConfigs,
  NeotestAdapters = NeotestAdapters,
}
