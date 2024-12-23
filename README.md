# dotfiles
My dot files 

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
* [Micro Editor](https://github.com/zyedidia/micro)
* [LazyGit](https://github.com/jesseduffield/lazygit)

### Installation script

```powershell
# Modules
Install-Module -Name PowerShellGet -Force
Install-Module -Name Terminal-Icons -Repository PSGallery
Install-Module -Name "F7History"

# Cli
choco install fd -y
choco install fzf -y
choco install bat -y
choco install ripgrep -y
choco install jq -y
choco install far -y
choco install micro -y
choco install lazygit -y
choco install oh-my-posh -y

# dotnet tools
dotnet tool install -g csharprepl
```