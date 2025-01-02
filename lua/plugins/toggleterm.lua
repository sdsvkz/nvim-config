return {
  'akinsho/toggleterm.nvim',
  version = "*",
  config = true,
  opts = {
    open_mapping = '<LEADER>xT',
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
        "<LEADER>xg", mode = { "n", "t" },
        function() lazygit:toggle() end,
        desc = "Toggle Lazygit session"
      },
    }
 end
}

