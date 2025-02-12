local Groups = require("config.key_groups").Groups

return {
  'akinsho/toggleterm.nvim',
  version = "*",
  config = true,
  opts = {
    open_mapping = '<LEADER>wT',
    -- direction = 'float'
    insert_mappings = false,
  },
  keys = function (_, _)
    local Terminal = require('toggleterm.terminal').Terminal
    local lazygit = Terminal:new({
      cmd = "lazygit",
      hidden = true,
      direction = "float",
    })
    return {
      {
        Groups.UI.lhs .. "g", mode = { "n", "t" },
        function() lazygit:toggle() end,
        desc = "Toggle Lazygit session"
      },
    }
 end
}

