setopt histignorealldups
HISTSIZE=2000
SAVEHIST="$HISTSIZE"
HISTFILE=~/.zsh_history

# autocomplete
autoload -Uz compinit && compinit

# for WSL2
cd ~

# set aliases if commands exist
command -v eza > /dev/null && alias ls='eza '
command -v nano > /dev/null && export EDITOR='nano --nohelp '

fetchShortHostname() {
    # try the hostname command
    command -v hostname && {hostname; return 0}

    # try the hostname file
    [ -f /etc/hostname ] && {cat /etc/hostname; return 0}

    # give up and use a question mark
    echo '?'
}

longPrompt() {
    export PROMPT="%F{yellow}[$(fetchShortHostname)]%f %(?.%F{green}✓%f.%F{red}✗%f) %F{cyan}%~%f » "
}

shortPrompt() {
    export PROMPT="» "
}

packageCheck() {
    for pkg in code curl eza firefox fzf git i3lock kitty micro nano sudo sudo-rs tldr tmux; do
        command -v "$pkg" > /dev/null && echo "\e[0;32m[Installed]\e[0m ${pkg}" || echo "\e[0;31m[Not installed]\e[0m ${pkg}"
    done
}

_() {
    command -v dialog > /dev/null || { echo "Dialog not found; however, it is a dependency of this script."; return 1; }
    x="$(dialog --keep-tite --menu 'Select a command' -1 -1 -1 1 'Short prompt' 2 'Long prompt' 3 'Package check' 2>&1 >/dev/tty)"
    case "$x" in
    1) shortPrompt;;
    2) longPrompt;;
    3) packageCheck;;
    esac
}
longPrompt

# default to Wayland
export ELECTRON_OZONE_PLATFORM_HINT=wayland

# set some keys
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char
