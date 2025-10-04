local vkzlib = Vkz.vkzlib
local deep_merge = vkzlib.Data.table.deep_merge
local default = require("profiles.default")
local utils = require("profiles.utils")
local options = require("profiles.options")

local neovide_fullscreen_handle = utils.create_file("neovide_fullscreen.state")

local function neovide()
	vim.g.neovide_theme = "auto"
	vim.o.guifont = "CaskaydiaCove Nerd Font"
	vim.g.neovide_opacity = 0.6
	vim.g.neovide_normal_opacity = 0.6
	vim.g.neovide_hide_mouse_when_typing = true
	vim.g.neovide_remember_window_size = true
	-- Restore fullscreen state
	local res = neovide_fullscreen_handle:read()
	-- Vkz.log.d(vkzlib.core.to_string(res))
	local neovide_fullscreen = res.content
	if neovide_fullscreen then
		vim.g.neovide_fullscreen = neovide_fullscreen == "1" and true or false
	end

	-- Try make windows title bar less out of place
	if default.preference.os == options.System.Windows then
		vim.api.nvim_create_autocmd({ "ColorScheme" }, {
			group = vkzlib.vim.augroup("neovide", "windows_title_bar"),
			pattern = "*",
			callback = function(_)
				vim.g.neovide_title_text_color =
					string.format("%x", vim.api.nvim_get_hl(0, { id = vim.api.nvim_get_hl_id_by_name("Normal") }).fg)
				vim.g.neovide_title_background_color =
					string.format("%x", vim.api.nvim_get_hl(0, { id = vim.api.nvim_get_hl_id_by_name("Normal") }).bg)
			end,
		})
	end

	-- Set keymap for quickly toggle fullscreen
	vim.api.nvim_create_autocmd({ "VimEnter" }, {
		group = vkzlib.vim.augroup("neovide", "toggle_fullscreen_keymap"),
		pattern = "*",
		callback = function(_)
			vim.keymap.set({ "n", "v" }, "<F11>", function()
        local is_fullscreen = vim.g.neovide_fullscreen == nil and true or not vim.g.neovide_fullscreen
				vim.g.neovide_fullscreen = is_fullscreen
				neovide_fullscreen_handle:write(is_fullscreen == true and "1" or "0")
			end)
		end,
	})

  -- This doesn't work
  --
	-- Remember fullscreen state
	-- vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
	-- 	group = vkzlib.vim.augroup("neovide", "save_fullscreen_state"),
	-- 	pattern = "n",
	-- 	callback = function(_)
	-- 		Vkz.log.d("Saving fullscreen state")
 --      neovide_fullscreen_handle:write(vim.g.neovide_fullscreen == true and "1" or "0")
	-- 	end,
	-- })
end

---@type profiles.Profile
local profile = {
	---@type profiles.Profile.Preference
	preference = {
		cc = "D:/mingw1310_64/bin/gcc.exe",
		use_mason = true,
		enable_inlay_hint = true,
		use_ai = true,
		use_global_statusline = true,
		mouse = "",
		enable_discord_rich_presence = true,
		config_neovide = neovide,
		---@module "lazy"

		plugin_opts = {
			---@module "codecompanion"

			codecompanion = function(_, opts)
				---@param is_acp boolean
				---@param adapter_name string
				---@param adapter_opts table
				---@return CodeCompanion.ACPAdapter | CodeCompanion.HTTPAdapter
				local function extend(is_acp, adapter_name, adapter_opts)
					local adapter = is_acp and opts.adapters.acp or opts.adapters.http
					adapter = adapter[adapter_name]
					---@cast adapter nil | fun(): CodeCompanion.ACPAdapter | CodeCompanion.HTTPAdapter
					if type(adapter) == "function" then
						local gemini_cli = adapter()
						return gemini_cli:extend(adapter_opts)
					else
						return require("codecompanion.adapters").extend("gemini_cli", adapter_opts)
					end
				end
				return deep_merge("force", opts, {
					adapters = {
						acp = {
							gemini_cli = function()
								local identity_path = vim.env.AGE_IDENTITY_PATH
								local gemini_api_key_path = vim.env.AGE_GEMINI_API_KEY_PATH
								Vkz.log.d(
									string.format(
										"AGE_IDENTITY_PATH = %s\nAGE_GEMINI_API_KEY_PATH = %s",
										identity_path,
										gemini_api_key_path
									)
								)
								local new_opts = {}
								if type(identity_path) == "string" and type(gemini_api_key_path) == "string" then
									new_opts = {
										env = {
											api_key = string.format(
												"cmd: age -d -i %s %s",
												identity_path,
												gemini_api_key_path
											),
										},
									}
								end
								return extend(true, "gemini_cli", new_opts)
							end,
						},
					},
				})
			end,
      ---@module "mcphub"

      ---@type MCPHub.Config
      mcphub = {
        ---@param _ MCPHub.JobContext
        ---@return table
        global_env = function (_)
          local env = {}
          local function copy_vim_env(NAME)
            env[NAME] = vim.env[NAME]
          end
          copy_vim_env("HTTP_PROXY")
          copy_vim_env("HTTPS_PROXY")
          return env
        end
      },
			---@module "bufferline"

			bufferline = function(_, opts)
				local profile = require("profiles")
				if profile.appearence.theme.colorscheme:find("catppuccin") then
					---@cast opts bufferline.UserConfig
					opts.highlights = require("catppuccin.special.bufferline").get_theme()
				end
			end,
		},
	},
	---@type profiles.Profile.Appearance
	appearence = {
		---@type profiles.Profile.Appearance.Theme
		theme = options.Themes.catppuccin,
	},
	---@type profiles.Profile.Editor
	editor = {
		tab_size = 2,
	},
	---@type profiles.Profile.Languages
	languages = {
		---@type table<string | string[], profiles.Profile.Languages.Language>
		custom = {
			angular = {
				enable = true,
			},
			c = {
				enable = true,
			},
      cpp = {
        enable = true,
      },
			cmake = {
				enable = true,
			},
			haskell = {
				enable = true,
			},
			json = {
				enable = true,
			},
			markdown = {
				enable = true,
			},
			lua = {
				enable = true,
			},
			python = {
				enable = true,
			},
			ps1 = {
				enable = false,
			},
			bash = {
				enable = false,
			},
      sh = {
        enable = false,
      },
			rust = {
				enable = true,
			},
      javascript = {
        enable = true,
      },
      typescript = {
        enable = true,
      },
			yaml = {
				enable = true,
			},
		},
	},
	---@type profiles.Profile.Debugging
	debugging = {
		log_level = vim.log.levels.DEBUG,
	},
}

return profile
