local deep_merge = Vkzlib.table.deep_merge

---Retrieve required tools from profile
---@param LANGUAGES profiles.Profile.Languages
local function get_language_tools(LANGUAGES)
  -- TODO: Extract dap as soon as nvim-dap is added

  ---@type { [string]: [string] }
  local formatters = {}
  ---@type { [string]: [string] }
  local linters = {}
  ---@type { [config.lsp.Server.MasonConfig]: config.lsp.Handler }
  local ls = {}

  -- All Languages are disabled by default
  -- So see if any of them in `custom` has been enabled
  for ft, lang in pairs(LANGUAGES.custom) do
    ---@cast ft +string
    ---@cast lang +profiles.Profile.Languages.Language
    if lang.enable then
      ---@type profiles.Profile.Languages.Language
      local default = LANGUAGES.supported[ft]
      if type(default) == "table" then
        formatters[ft] = vim.deepcopy(default.tools.formatters, true)
        linters[ft] = vim.deepcopy(default.tools.linters, true)
        ls = deep_merge("force", ls, default.tools.ls)
      end
      -- TODO: If it is enabled, do with tools
      -- Remember, use `supported` as backup setting if any, say, not supplied
    end
  end

  return {
    formatters = formatters,
    linters = linters,
    ls = ls,
  }
end

return {
  get_language_tools = get_language_tools,
}
