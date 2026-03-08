# dotfiles
My dot files

## Installation (macOS)

Clone the repository and run the install script:

```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
./install.sh
```

The script will back up any existing config files (e.g. `~/.gitconfig` → `~/.gitconfig_backup`) before symlinking the dotfiles in place. It currently sets up:

- **Git** — symlinks `git/gitconfig` to `~/.gitconfig`
- **Starship** — symlinks `starship.toml` to `~/.config/starship.toml`
- **Zsh** — symlinks `macos/zshrc` to `~/.zshrc`
- **Tmux** — symlinks `macos/tmux.conf` to `~/.tmux.conf`
- **Vim** — symlinks `macos/vimrc` to `~/.vimrc`

## Git

Git only contains alias and not much more...

## Powershell

### Modules

* [PSReadLine](https://github.com/PowerShell/PSReadLine)
* [Terminal-Icons](https://github.com/devblackops/Terminal-Icons)
* [F7History](https://github.com/gui-cs/F7History)
* [Oh-my-posh](https://ohmyposh.dev/)

### Cli tools

* [fd](https://github.com/sharkdp/fd)
* [fzf](https://github.com/junegunn/fzf)
* [bat](https://github.com/sharkdp/bat)
* [RipGrep](https://github.com/BurntSushi/ripgrep)
* [jq](https://github.com/jqlang/jq)
* [btop](https://github.com/aristocratos/btop4win)
* [csrepl](https://github.com/waf/CSharpRepl)
* [Far Manager](https://www.farmanager.com/)
* [vim](https://www.vim.org/)
* [LazyGit](https://github.com/jesseduffield/lazygit)
* [Ntop](https://github.com/gsass1/NTop)

### Installation script

Execute `install.ps1` once to install all the needed tools, then add the following line to your `$PROFILE`:

```powershell
."<path_to>\profile.ps1"
```
