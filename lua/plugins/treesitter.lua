return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function ()
    ---@diagnostic disable-next-line: missing-fields
    require("nvim-treesitter.configs").setup {
      ensure_installed = {
        -- CLI
        "bash", "powershell",
        -- Text
        "markdown", "markdown_inline", "latex", "todotxt",
        -- Docs
        "comment", "doxygen", "jsdoc", "luadoc",
        -- Data
        "csv", "psv", "tsv", "json", "json5", "jsonc", "http",
        -- Git
        "git_config", "git_rebase", "gitattributes", "gitcommit", "gitignore",
        -- Configuration
        "make", "cmake", "dockerfile", "ini", "meson", "nginx", "ninja", "requirements", "toml", "xml", "yaml",
        -- Vim
        "vim", "vimdoc", "query",

        -- Languages

        -- Assembly
        "asm",
        -- SQL
        "sql",
        -- C Family
        "c", "objc", "cpp", "c_sharp", "llvm", "printf",
        -- Haskell
        "haskell", "haskell_persistent",
        -- JVM
        "java", "kotlin",
        -- Lua
        "lua", "luap", "luau",
        -- Python
        "python",
        -- Web
        "html", "css", "javascript",
        "scss", "typescript", "tsx",
        "vue"
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true
      }
    }
  end
}
