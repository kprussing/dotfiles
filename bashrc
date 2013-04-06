# Determine the operating system
OS=$(uname | tr A-Z a-z)

# Set my prompt colors.
if [[ "$SSH_TTY" ]]; then
    hcol="0;32" # SSH gives us a green host
    pcol="1;34" # and a bright blue path.
elif [[ "$OS" = "darwin" ]]; then
    hcol="1;35" # Magenta on Darwin
    pcol="1;34" # with a blue path.
else
    hcol="1;32" # Otherwise, a green host
    pcol="1;33" # and yellow path.
fi
PS1="\n"
PS1=$PS1"\[\e[${hcol}m\]\u@\h:"
PS1=$PS1"\[\e[${pcol}m\]\w"
PS1=$PS1"\[\e[0m\]\n\s-\v\$ "
export PS1

# Set my editor
export EDITOR=vim

# Set some aliases
alias xvim='xterm -e vim'   # I don't like gVim and this is tolerable.
alias tmux='tmux -2'        # Force 256 colors in tmux.

# LS is tricky due to BSD vs GNU versions.
if [[ "$OS" = "darwin" ]]; then
    # Set the command line colors. Based on information from
    # osxdaily.com/2012/02/21/add-color-to-the-terminal-in-mac-os-x/
    export CLICOLOR=1
    export LSCOLORS=ExFxCxDaBxegedabagacad
else
    alias ls='ls --color=auto'
fi

# Under windows, we'll need a bit of trickery for the python path.
if [[ $OS = *mingw* ]]; then
    alias python='py'
    alias python3='py -3.2'
    alias python3.2='py -3.2'
    alias python3.3='py -3'
fi

if [[ $OS = *cygwin* || $OS = *mingw* ]]; then
    # Go ahead and set the X forwarding display too.
    export DISPLAY=:0
fi

