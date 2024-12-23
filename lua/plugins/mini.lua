return {
  {
    'echasnovski/mini.nvim',
    version = false,
    init = function ()
      local modules = {
        -- General

        -- ['mini.files'] = true,
        -- For LSP mesage
        ['mini.notify'] = true,

        -- Editing

        ['mini.ai'] = true,
        ['mini.bracketed'] = true,
        ['mini.surround'] = true,
        -- ['mini.operators'] = true,
        ['mini.pairs'] = true,
        ['mini.jump2d'] = true,
        -- ['mini.pick'] = true,
        -- Visual
        -- ['mini.animate'] = true,
        -- ['mini.hipatterns'] = function(module)
        --   return {
        --     highlighters = {
        --       -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
        --       fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
        --       hack  = { pattern = '%f[%w]()HACK()%f[%W]',  group = 'MiniHipatternsHack'  },
        --       todo  = { pattern = '%f[%w]()TODO()%f[%W]',  group = 'MiniHipatternsTodo'  },
        --       note  = { pattern = '%f[%w]()NOTE()%f[%W]',  group = 'MiniHipatternsNote'  },
        --
        --       -- Highlight hex color strings (`#rrggbb`) using that color
        --       hex_color = module.gen_highlighter.hex_color(),
        --     },
        --   }
        -- end,
        -- ['mini.cursorword'] = true,
        -- ['mini.indentscope'] = true,
      }
      for module_name, getConfig in pairs(modules) do
        local module = require(module_name)
        if getConfig == true then
          module.setup()
        else
          module.setup(getConfig(module))
        end
      end
    end,
  },
}
