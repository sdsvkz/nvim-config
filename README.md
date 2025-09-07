# Neovim configuration

This is my own Neovim configuration and also, a shitty little library written by me.

## Requirements

- Neovim >= 0.11
- Git
- pip
- [uv](https://docs.astral.sh/uv/)
- Node.js (Latest LTS recommended)
- ripgrep
- a [Nerd Font](https://www.nerdfonts.com/) for display icons properly
- [luarocks](https://luarocks.org/) for installing `luacheck` (Optional, you can disable auto-install for `luacheck`)
- [jq](https://jqlang.org/) (Optional, for better MCPHub `servers.json` formatting)

## Notes

For installing tools using *mason.nvim*, see `:checkhealth mason`.

## Customization

### Create new profile

Check out [default profile](/lua/profiles/default.lua) to see available options.
For an example, [here is my profile](/lua/profiles/sdsvkz.lua).

## Warning

For anyone other than me. I make breaking changes pretty often. So I suggest fork this repo if you want to use my configuration.

