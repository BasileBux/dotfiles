# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
#
# Path to your Oh My Zsh installation.
printf '\n%.0s' {1..$LINES}
export ZSH="$HOME/.oh-my-zsh"

# ZSH_THEME="half-life"
# ZSH_THEME="custom-better"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Cool themes: cloud, half-life, nicoulaj, terminalparty, spaceship, bubblegum

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

plugins=(git)

source $ZSH/oh-my-zsh.sh

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh

# clear alias to have prompt always at bottom
alias clear='printf "\e[H\ec\e[${LINES}B"'

# configuration
alias zshconfig="nvim ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"
alias hyprconfig="cd ~/.config/hypr;/home/basileb/scripts/replaceTerm zed"
alias waybarconfig="cd ~/.config/waybar;nvim"
alias kittyconfig="cd ~/.config/kitty;nvim kitty.conf"
alias nvimconfig="cd ~/.config/nvim;nvim init.lua"

# system
alias up="sudo dnf upgrade -y;flatpak upgrade -y"
alias re="source ~/.zshrc"
alias battery="acpi"
alias wifi="nm-connection-editor"
alias codew="code --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland" # open vscode with wayland
alias vpn="hotspotshield"
alias vpns="hotspotshield account signin"
alias excalidraw="nohup brave-browser --app=https://excalidraw.com/ &"
alias asus="python3 ~/asusctl-python-ui/main.py"
alias zedd='/home/basileb/.config/hypr/scripts/replaceTerm zed'
alias codee='/home/basileb/.config/hypr/scripts/replaceTerm code'
alias nn='/home/basileb/.config/hypr/scripts/replaceTerm'

# useful
alias dot="sh ~/save_dotfiles.sh" # NOTE: rework this
alias record="wf-recorder --audio=bluez_output.60_AB_D2_45_2A_9C.1.monitor --file=rec.mp4"
alias change_directory="source ~/.config/hypr/scripts/re-cd.sh"
alias latexc="xelatex -shel-escape -8bit -synctex=1 -interaction=nonstopmode -file-line-error"

alias wif="python3 ~/wifi-ctl/main.py"

# custom junk
alias aperture="neofetch --ascii ~/Documents/as.txt" # WARNING: Not working, change to fastfetch
alias pfetch="neofetch --ascii_distro Fedora_small"  # Not working, change to fastfetch
alias s="sh ~/Documents/hello.sh"
alias h="cat ~/.zsh-alias-guide"
alias kbman="sh ~/.config/hypr/kbman.sh" # WARNING: Update because config changed
alias weather="curl www.wttr.in/lausanne"
alias curlt="sh ~/scripts/curl.sh"
alias hashw="sh ~/scripts/sha256_gen.sh"
alias whereami="pwd"
alias fe="yazi"
alias car="bat"
alias vim="nvim"
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

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export GPG_TTY=$(tty)
eval "$(zoxide init zsh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
