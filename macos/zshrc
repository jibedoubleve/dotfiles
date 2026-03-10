# ~/.bashrc
# ~/.zshrc

autoload -Uz compinit
compinit


eval "$(starship init zsh)"
[[ "$TERM_PROGRAM" == "CodeEditApp_Terminal" ]] && . "/Applications/CodeEdit.app/Contents/Resources/codeedit_shell_integration.zsh"


## Aliases
alias   g="git"
alias cls="clear"
alias sql="sqlite3"
alias   m="micro"
alias  dn="dotnet"
alias  lg="lazygit"
alias  mc="mc --nosubshell"
alias  ls="eza --color=always"
alias lsa="eza --color=always -lah"
alias   c="code"
alias pod="podman"
alias pc="podman-compose"

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# dotnet tools
export PATH=$HOME/.dotnet/tools:$PATH

## Ruby
source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
source /opt/homebrew/opt/chruby/share/chruby/auto.sh
chruby ruby-3.4.1 # run chruby to see actual version

# Yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# Zoxide
eval "$(zoxide init zsh)"

# Carapace
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)

