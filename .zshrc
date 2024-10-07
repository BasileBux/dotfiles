

# Path to your Oh My Zsh installation.
# printf '\n%.0s' {1..$LINES}
export ZSH="$HOME/.oh-my-zsh"

# ZSH_THEME="half-life"
ZSH_THEME=""

# Cool themes: half-life, terminalparty, bubblegum, darkblood, juanghurtado

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

plugins=(git)

source $ZSH/oh-my-zsh.sh

setopt nocorrect
unsetopt correct_all
unsetopt correct

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh

# clear alias to have prompt always at bottom
# alias clear='printf "\e[H\ec\e[${LINES}B"'

# configuration
alias zshconfig="nvim ~/.zshrc"
alias hyprconfig="cd ~/.config/hypr;zed ."
alias waybarconfig="cd ~/.config/waybar;nvim"
alias kittyconfig="cd ~/.config/kitty;nvim kitty.conf"
alias nvimconfig="cd ~/.config/nvim;nvim init.lua"

# system
alias up="sudo dnf upgrade -y;flatpak upgrade -y"
alias re="source ~/.zshrc"
alias codew="code --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland" # open vscode with wayland
alias zedd='/home/basileb/scripts/replaceTerm zed'
alias nn='/home/basileb/scripts/replaceTerm'
alias lg1="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all"
alias lg2="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'"

# useful
alias record="wf-recorder --audio=bluez_output.60_AB_D2_45_2A_9C.1.monitor --file=rec.mp4"
alias latexc="xelatex -shel-escape -8bit -synctex=1 -interaction=nonstopmode -file-line-error"

# custom junk
alias s="sh ~/Documents/hello.sh"
alias weather="curl www.wttr.in/lausanne"
alias whereami="pwd"
alias car="bat"
alias lg="lazygit"

# make dir and cd into it directly
function mkcd {
  if [ ! -n "$1" ]; then
    echo "Enter a directory name"
  elif [ -d $1 ]; then
    echo "\`$1' already exists"
  else
    mkdir $1 && cd $1
  fi
}

export PATH=$PATH:/home/basileb/.spicetify
export EDITOR=/usr/bin/nvim
export PATH=$HOME/.local/bin:$PATH

export SUDO_EDITOR="nvim"
alias "sudoedit"='function _sudoedit(){sudo -e "$1";};_sudoedit'

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export GPG_TTY=$(tty)
eval "$(zoxide init zsh)"

eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/rizzler.toml)"
