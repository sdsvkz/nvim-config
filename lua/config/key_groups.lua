---@module "which-key"

local map = Vkz.vkzlib.Data.table.map
local profile = require("profiles")

---@class config.keymap.Group.Template
---@field lhs string The key
---@field desc string Group description

---@class config.keymap.Group : config.keymap.Group.Template
---@field set fun(mode: string|string[], lhs: string, rhs: string|function, opts?: vim.keymap.set.Opts) `vim.keymap.set`

---Generate "set" for group
---@param template config.keymap.Group.Template
---@return config.keymap.Group
local function mk_group(template)
  ---@type config.keymap.Group
  return {
    lhs = template.lhs,
    desc = template.desc,
    set = function (mode, lhs, rhs, opts)
      vim.keymap.set(mode, template.lhs .. lhs, rhs, opts)
    end
  }
end

---Generate `groups` for `mk.add`
---@param groups table<string, config.keymap.Group>
---@return wk.Spec
local function get_mappings_from_groups(groups)
  ---@type table<string, string>
  local xs = {}

  for _, x in pairs(groups) do
    xs[x.lhs] = xs[x.lhs] and xs[x.lhs] .. " / " .. x.desc or x.desc
  end

  -- `mappings` for `mk.add` register groups
  ---@type wk.Spec
  local mappings = {}

  for lhs, desc in pairs(xs) do
    table.insert(mappings, { lhs, group = desc })
  end

  return mappings
end

-- TODO: Subgroup

---@type table<string, config.keymap.Group.Template>
local groups = {
  Buffer  = { lhs = "<LEADER>b", desc = "Buffer" },
  Setting = { lhs = "<LEADER>,", desc = "Settings" },
  Trouble = { lhs = "<LEADER>x", desc = "UIs (Trouble)" },
  Telescope = { lhs = "<LEADER>t", desc = "UIs (Telescope)" },
  UI = { lhs = "<LEADER>w", desc = "UIs" },
  Show = { lhs = "<LEADER>s", desc = "Show" },
  Send = { lhs = "<LEADER>s", desc = "Send" },
  Goto = { lhs = "<LEADER>g", desc = "Goto" },
  Generate = { lhs = "<LEADER>g", desc = "Generate" },
  Peek = { lhs = "<LEADER>p", desc = "Peek" },
  Debugging = { lhs = "<LEADER>d", desc = "Debugging" },
  Editing = { lhs = "<LEADER>e", desc = "Editing" },
}

if profile.preference.use_ai then
  groups.CodeCompanion = { lhs = "<LEADER>c", desc = "CodeCompanion" }
end

local Groups = map(mk_group, groups)
---@cast Groups table<string, config.keymap.Group>

local Mappings = get_mappings_from_groups(Groups)

return {
  Groups = Groups,
  Mappings = Mappings,
  utils = {
    mk_group = mk_group,
    get_mappings_from_groups = get_mappings_from_groups,
  },
}
