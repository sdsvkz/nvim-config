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
        local is_tools_exists = type(lang.tools) == "table"
        formatters[ft] = is_tools_exists and
          lang.tools.formatters or
          Vkzlib.core.deep_copy(default.tools.formatters, true)
        linters[ft] = is_tools_exists and
          lang.tools.linters or
          Vkzlib.core.deep_copy(default.tools.linters, true)
        ls = deep_merge("force", ls, is_tools_exists and
          lang.tools.ls or
          default.tools.ls
        )
      end
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
