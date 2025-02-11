---@module "conform"

local deep_merge = Vkzlib.table.deep_merge

---@param LANGS table<string | string[], profiles.Profile.Languages.Language>
---@param ft string
---@return boolean
local function is_ft_support_enabled(LANGS, ft)
  for FILETYPES, LANG in pairs(LANGS) do
    if type(FILETYPES) == "string" then
      if FILETYPES == ft and LANG.enable == true then
        return true
      end
    else
      for _, filetype in ipairs(FILETYPES) do
        if filetype == ft and LANG.enable == true then
          return true
        end
      end
    end
  end
  return false
end

---Retrieve required tools from profile
---@param LANGUAGES profiles.Profile.Languages
---@return { formatters: table<string, conform.FiletypeFormatter>, linters: table<string, (string | config.lint.LinterSpec)[]>, ls: { [config.lsp.Server.MasonConfig]: config.lsp.Handler } }
local function get_language_tools(LANGUAGES)
  -- TODO: Extract dap as soon as nvim-dap is added

  ---@type table<string, conform.FiletypeFormatter>
  local formatters = {}
  ---@type table<string, (string | config.lint.LinterSpec)[]>
  local linters = {}
  ---@type { [config.lsp.Server.MasonConfig]: config.lsp.Handler }
  local ls = {}

  ---@type table<string, profiles.Profile.Languages.Language>
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

  -- TODO: Make enable by default possible
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
            default.tools.ls or {}
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

---comment
---@param colorscheme string
---@param theme_config (fun(plugin: table, opts: table, spec: LazyPlugin) | true)?
---@return ((fun(main: string): fun(self: LazyPlugin, opts: table)) | true)?
local function generate_config(colorscheme, theme_config)
  if theme_config == true or theme_config == nil then
    return theme_config
  end
  return function (main)
    return function (self, opts)
      -- This prevent failing from loading not existing module
      local ok, plugin = pcall(require, main)
      if ok then
        theme_config(plugin, opts, self)
        -- This prevent setup code of other themes from changing colorscheme
        vim.cmd.colorscheme(colorscheme)
      end
    end
  end
end

return {
  is_ft_support_enabled = is_ft_support_enabled,
  generate_config = generate_config,
  get_language_tools = get_language_tools,
}
