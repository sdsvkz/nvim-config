---@diagnostic disable: missing-fields

---@class (exact) config.keymap.Group
---@field lhs string The key
---@field desc string Group description
---@field set fun(mode: string|string[], lhs: string, rhs: string|function, opts?: vim.keymap.set.Opts) `vim.keymap.set`

---Generate "set" for group
---@param group_lhs string
---@param desc string
---@return config.keymap.Group
local function mk_group(group_lhs, desc)
  ---@type config.keymap.Group
  return {
    lhs = group_lhs,
    desc = desc,
    set = function (mode, lhs, rhs, opts)
      vim.keymap.set(mode, group_lhs .. lhs, rhs, opts)
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

---@type table<string, config.keymap.Group>
local Groups = {
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

for key, value in pairs(Groups) do
  Groups[key] = mk_group(value.lhs, value.desc)
end

local Mappings = get_mappings_from_groups(Groups)

return {
  Groups = Groups,
  Mappings = Mappings,
  utils = {
    mk_group = mk_group,
    get_mappings_from_groups = get_mappings_from_groups,
  },
}
