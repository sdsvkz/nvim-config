local deep_merge = Vkzlib.table.deep_merge

---Retrieve required tools from profile
---@param LANGUAGES profiles.Profile.Languages
local function get_language_tools(LANGUAGES)
  -- TODO: Extract dap as soon as nvim-dap is added

  ---@type { [string]: string[] }
  local formatters = {}
  ---@type { [string]: string[] }
  local linters = {}
  ---@type { [config.lsp.Server.MasonConfig]: config.lsp.Handler }
  local ls = {}

  ---@type { [string]: profiles.Profile.Languages.Language }
  local supported = {}
  for ft, lang in pairs(LANGUAGES.supported) do
    ---@cast ft string | string[]
    ---@cast lang profiles.Profile.Languages.Language
    if type(ft) == "string" then
      supported[ft] = lang
    else
      for _, v in ipairs(ft) do
        supported[v] = lang
      end
    end
  end
  Log.t(Vkzlib.core.to_string(supported))

  -- All Languages are disabled by default
  -- So see if any of them in `custom` has been enabled
  for ft, lang in pairs(LANGUAGES.custom) do
    if lang.enable then
      ---Process to extract tools for `filetype`, from `lang`
      ---@param filetype string
      local function extract(filetype)
        assert(type(filetype) == "string", "Extracting tools for invalid filetype")
        -- Default toolset if corresponding tools not exists
        local default = supported[filetype]
        if type(default) == "table" then
          local is_tools_exists = type(lang.tools) == "table"
          formatters[filetype] = is_tools_exists and
            lang.tools.formatters or
            Vkzlib.core.deep_copy(default.tools.formatters, true)
          linters[filetype] = is_tools_exists and
            lang.tools.linters or
            Vkzlib.core.deep_copy(default.tools.linters, true)
          ls = deep_merge("force", ls, is_tools_exists and
            lang.tools.ls or
            default.tools.ls
          )
        else
          formatters[filetype] = lang.tools.formatters
          linters[filetype] = lang.tools.linters
          ls = deep_merge('force', ls, lang.tools.ls)
        end
      end

      if type(ft) == "string" then
        extract(ft)
      else
        for _, v in ipairs(ft) do
          extract(v)
        end
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
