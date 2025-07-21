# ddev-dev-shell Addon

[![add-on registry](https://img.shields.io/badge/DDEV-Add--on_Registry-blue)](https://addons.ddev.com)

## Overview

This add-on provides a modern, pre-configured shell environment for your [DDEV](https://ddev.com) project, including a rich set of CLI tools, plugins, and productivity features out of the box.

### Included Tools

The following tools are installed and kept up-to-date via GitHub releases:

| Tool                                                                 | Description                                 |
|----------------------------------------------------------------------|---------------------------------------------|
| [fish](https://fishshell.com)                                        | User-friendly interactive shell             |
| [starship](https://starship.rs)                                      | Fast, customizable shell prompt             |
| [neovim](https://github.com/neovim/neovim)                           | Modern Vim-based text editor                |
| [bat](https://github.com/sharkdp/bat)                                | Cat clone with syntax highlighting          |
| [btop](https://github.com/aristocratos/btop)                         | Resource monitor                            |
| [diskusage](https://github.com/chenquan/diskusage)                   | Disk usage analyzer                         |
| [difftastic](https://github.com/Wilfred/difftastic)                  | Diff tool with syntax highlighting          |
| [direnv](https://github.com/direnv/direnv)                           | Environment variable manager                |
| [eza](https://github.com/eza-community/eza)                          | Modern replacement for 'ls'                 |
| [fd](https://github.com/sharkdp/fd)                                  | Simple, fast and user-friendly 'find'       |
| [glow](https://github.com/charmbracelet/glow)                        | Markdown renderer in the terminal           |
| [gitleaks](https://github.com/gitleaks/gitleaks)                     | Git secrets scanner                         |
| [grex](https://github.com/pemistahl/grex)                            | Regex generator from examples               |
| [fzf](https://github.com/junegunn/fzf)                               | Fuzzy finder                               |
| [lazygit](https://github.com/jesseduffield/lazygit)                  | Simple terminal UI for git                  |
| [lazysql](https://github.com/jorgerojas26/lazysql)                   | Terminal SQL client                         |
| [navi](https://github.com/denisidoro/navi)                           | Interactive cheatsheet tool                 |
| [oha](https://github.com/hatoo/oha)                                  | HTTP load generator                         |
| [ouch](https://github.com/ouch-org/ouch)                             | Compression and decompression tool          |
| [rustscan](https://github.com/bee-san/RustScan)                      | Fast port scanner                           |
| [tailspin](https://github.com/bensadeh/tailspin)                     | Log file viewer                             |
| [duf](https://github.com/muesli/duf)                                 | Disk usage/free utility                     |
| [zoxide](https://github.com/ajeetdsouza/zoxide)                      | Smarter cd command                          |

Additionally, the environment includes many shell plugins and aliases for productivity.

## Installation

```bash
ddev add-on get moke13-dev/ddev-dev-shell
ddev restart
```

After installation, commit the `.ddev` directory to version control.

## Usage

After installation, use `ddev ssh` to enter your project container. All tools, aliases, and plugins are ready to use.

- User configs: `homeadditions/`
- Tool Dockerfiles: `web-build/`

## Adding or Updating Tools

To add a new tool or update an existing one, extend the tool list in `.github/scripts/update_github_installer_urls.sh` by adding a new `ENTRY_*` block with the appropriate GitHub repository and file pattern. This ensures the tool is kept up-to-date automatically.

## License

MIT License © 2025 moke13-dev