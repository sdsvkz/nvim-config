return {
    'brglng/vim-im-select',
    version = false,
    init = function ()
      -- im-select executable path
      vim.g.im_select_command = vim.fn.stdpath("config") .. "\\bin\\im-select.exe"
      -- Get by run im-select.exe in command line
      vim.g.im_select_default = "1033"
      -- If your desktop already switches input methods among different windows/applications,
      -- you may want to set this option to 0
      vim.g.im_select_enable_focus_events = 0
      -- Not gonna use IM for command
      vim.g.im_select_enable_cmd_line = 0
    end
}
