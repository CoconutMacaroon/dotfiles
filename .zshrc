setopt histignorealldups
HISTSIZE=2000
SAVEHIST="$HISTSIZE"
HISTFILE=~/.zsh_history

# autocomplete
autoload -Uz compinit && compinit

# for WSL2
cd ~

# set aliases if commands exist
command -v exa > /dev/null && alias ls='exa '
command -v nano > /dev/null && export EDITOR='nano --nohelp '

longPrompt() {
    export PROMPT="%F{yellow}[$(hostname)]%f %(?.%F{green}✓%f.%F{red}✗%f) %F{cyan}%~%f » "
}

shortPrompt() {
    export PROMPT="» "
}

_() {
    x="$(dialog --keep-tite --menu 'Select a command' -1 -1 -1 1 'Short prompt' 2 'Long prompt' 2>&1 >/dev/tty)"
    case "$x" in
    1) shortPrompt;;
    2) longPrompt;;
    esac
}
longPrompt
