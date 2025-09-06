local profile = require("profiles")
local deep_merge = Vkz.vkzlib.Data.table.deep_merge

local opts = function(_, o)
	local lualine_c = {}

	-- AI specific status
	if profile.preference.use_ai == true then
		-- Component for showing LLM request status
		local llm_indicator = require("lualine.component"):extend()

		llm_indicator.processing = false
		llm_indicator.spinner_index = 1

		local spinner_symbols = {
			"⠋",
			"⠙",
			"⠹",
			"⠸",
			"⠼",
			"⠴",
			"⠦",
			"⠧",
			"⠇",
			"⠏",
		}
		local spinner_symbols_len = 10

		-- Initializer
		function llm_indicator:init(options)
			llm_indicator.super.init(self, options)

			local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

			vim.api.nvim_create_autocmd({ "User" }, {
				pattern = "CodeCompanionRequest*",
				group = group,
				callback = function(request)
					if request.match == "CodeCompanionRequestStarted" then
						self.processing = true
					elseif request.match == "CodeCompanionRequestFinished" then
						self.processing = false
					end
				end,
			})
		end

		-- Function that runs every time statusline is updated
		function llm_indicator:update_status()
			if self.processing then
				self.spinner_index = (self.spinner_index % spinner_symbols_len) + 1
				return spinner_symbols[self.spinner_index]
			else
				return nil
			end
		end

		table.insert(lualine_c, llm_indicator)
	end

	return deep_merge("force", o, {
		options = {
			theme = "auto",
			globalstatus = true,
		},
		sections = {
			lualine_a = { "mode", "diagnostics" },
			lualine_b = {
				"branch",
				function()
					return require("auto-session.lib").current_session_name(true)
				end,
				"diff",
			},
			lualine_c = lualine_c,
			lualine_x = {
				{
					"aerial",
					colored = true,
				},
				"filename",
				"filetype",
			},
			lualine_y = { "encoding" },
			lualine_z = { "location" },
		},
		-- tabline = {
		--   lualine_a = {'buffers'},
		--   lualine_b = {},
		--   lualine_c = {},
		--   lualine_x = {},
		--   lualine_y = {},
		--   lualine_z = {'tabs'}
		-- },
		extensions = {
			"aerial",
			"lazy",
			"mason",
			"nvim-dap-ui",
			"nvim-tree",
			"toggleterm",
			"trouble",
			"quickfix",
		},
		lsp_saga = false,
	})
end

---@type LazyPluginSpec
return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"rmagatti/auto-session",
	},
	opts = profile.utils.merge_plugin_opts(Vkz.vkzlib.io.lua.get_caller_module_path(), opts),
	init = function()
		if profile.preference.use_global_statusline == true then
			-- Use global statusline
			vim.opt.laststatus = 3
		end
	end,
}
