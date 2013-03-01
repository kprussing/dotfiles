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
    alias ls='ls --colour=auto'
fi

# Under windows, we'll need a bit of trickery for the python path.
if [[ $OS = *cygwin* || $OS = *mingw* ]]; then
    PYTHON3DIR=/c/Programs/Python/3.2.3
    PYTHON2DIR=/c/Programs/Python/2.7.3
    if [[ $OS = *cygwin* ]]; then
        PYTHON3DIR=/cygdrive$PYTHON3DIR
        PYTHON2DIR=/cygdrive$PYTHON2DIR
    fi
    export PYTHON3DIR
    export PYTHON2DIR
    alias python2='${PYTHON2DIR}/python -E'
    alias python3='${PYTHON3DIR}/python -E'

    # Go ahead and set the X forwarding display too.
    export DISPLAY=:0
fi

# If the X server is running, update the database. I really don't know
# if this is even working correctly.
if [[ -f .Xresources ]]; then
    if ! xrdb .Xresources; then
        echo "No X server at \$DISPLAY [$DISPLAY]" >& 2
    fi
fi
