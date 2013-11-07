#--------1---------2---------3---------4---------5---------6---------7--
# General settings.

# Determine the operating system
OS=$(uname | tr A-Z a-z)

# Tell bash to check the window size after each command.
shopt -s checkwinsize

# Set my editor and pager
export EDITOR=vim
export VISUAL=$EDITOR
export PAGER=less

export LESS="-i -g -R"

# Make less colorful!
#export LESS_TERMCAP_mb=$'\e[01;31m'
#export LESS_TERMCAP_md=$'\e[01;31m'
#export LESS_TERMCAP_me=$'\e[0m'
#export LESS_TERMCAP_se=$'\e[0m'
#export LESS_TERMCAP_so=$'\e[01;44;33m'
#export LESS_TERMCAP_ue=$'\e[0m'
#export LESS_TERMCAP_us=$"'"$GREEN"'"
#export LESS_TERMCAP_us=$'\e[01;32m'

# Use vi bindings for bash
set -o vi


#--------1---------2---------3---------4---------5---------6---------7--
# Utility functions for updating paths.
function path_append () {
    # Append a path ($2) to a variable ($1) if it is not already in the
    # variable and exists.
    if [[ -z "$1" ]]; then
        # If the string is uninitialized, just create the path
        [ -d $2 ] && echo $2
    else
        # Check for duplicate paths.
        if echo $1 | grep -q "$2"; then
            echo $1
        else
            [ -d $2 ] && echo $1:$2 || echo $1
        fi
    fi
    return
}

function path_remove () {
    # Remove a path ($2) from a variable ($1) if it occurs in the path.
    # Don't forget to clean up those ugly duplicate colons.
    echo $1 | sed -e "s|$2||" -e "s|::|:|"
    return
}

#--------1---------2---------3---------4---------5---------6---------7--
# Update the paths based on how I have things installed.
paths="
    $HOME/.scripts
    $HOME/.local/bin
    $HOME/.local/scripts
    /opt/local/bin
    /opt/local/sbin
    /opt/android-sdk-macosx/tools
    /opt/android-sdk-macosx/platform-tools
    /nagfor/bin
"
for p in $paths; do
    BIN=$(path_append "$BIN" "$p")
done
# Prepend PATH with my paths.
if [[ ! -z "$BIN" ]]; then
    export PATH=$BIN:$PATH
fi

# For some reason, the man path is not updated correctly by default.  To
# be fair, I no longer remember which system is the culprit.  I know
# installing to my home directory messes things up.
paths="
    /usr/share/man
    /usr/local/man
    /opt/local/share/man
    /opt/X11/share/man
    $HOME/.local/man
    $HOME/.local/share/man
"
for p in $paths; do
    MANPATH=$(path_append "$MANPATH" "$p")
done
if [[ ! -z "$MANPATH" ]]; then
    export MANPATH
fi

# Update the library path for building in my home directory.  While
# we're at it, we might as well check the package configuration too.
paths="
    $HOME/.local/lib
    $HOME/.local/lib64
"
for p in $paths; do
    LD_LIBRARY_PATH=$(path_append "$LD_LIBRARY_PATH" "$p")
    PKG_CONFIG_PATH=$(path_append "$PKG_CONFIG_PATH" "$p"/pkgconfig)
done
if [[ ! -z "$LD_LIBRARY_PATH" ]]; then
    export LD_LIBRARY_PATH
fi
if [[ ! -z "$PKG_CONFIG_PATH" ]]; then
    export PKG_CONFIG_PATH
fi

#--------1---------2---------3---------4---------5---------6---------7--
# Make the colors clear.  First the foreground.
BLACK='\e[30m'
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
MAGENTA='\e[35m'
CYAN='\e[36m'
WHITE='\e[37m'

# Next, the background
BGBLACK='\e[40m'
BGRED='\e[41m'
BGGREEN='\e[42m'
BGYELLOW='\e[43m'
BGBLUE='\e[44m'
BGMAGENTA='\e[45m'
BGCYAN='\e[46m'
BGWHITE='\e[47m'

# Modifiers
RESET='\e[0m'
BOLD='\e[1m'
UNDERLINE='\e[4m'
BLINK='\e[5m'

#--------1---------2---------3---------4---------5---------6---------7--
# Set my prompt colors.  First, check to see if the user is root.
if [[ $EUID -eq "0" ]]; then
    # Annoy the #@!$ out of me.  Cyan seems to give the best contrast.
    usr="\[$BOLD$RED$BLINK$CYAN\]\u\[$RESET\]"
else
    # Green is best!
    usr="\[$BOLD$GREEN\]\u\[$RESET\]"
fi

# Determine the host and set the host and path colors
if [[ "$SSH_TTY" ]]; then
    # Use green and blue if we are using ssh.
    hst="\[$BOLD$GREEN\]\h\[$RESET\]"
    pth="\[$BOLD$BLUE\]\w\[$RESET\]"
elif [[ "$OS" = "darwin" ]]; then
    # I like magenta on the man page theme with a blue path.
    hst="\[$BOLD$MAGENTA\]\h\[$RESET\]"
    pth="\[$BOLD$BLUE\]\w\[$RESET\]"
elif [[ "$OS" = *cgwin* || "$OS" = *mingw* ]]; then
    # Let's try cyan with yellow for Windows.
    hst="\[$BOLD$CYAN\]\h\[$RESET\]"
    pth="\[$BOLD$YELLOW\]\w\[$RESET\]"
else
    # And no color is the default.
    hst="\h"
    pth="\w"
fi

# Adapted from http://www.opinionatedprogrammer.com/2011/01/colorful-bash-prompt-reflecting-git-status
# with inspiration from Steve Losh's Mercurial prompt.
function repo_prompt() {
    # Check for repositories
    local status="$(git status -unormal 2>&1)"
    #
    if ! [[ "$status" =~ Not\ a\ git\ repository ]]; then
        # Get the branch name
        if [[ "$status" =~ On\ branch\ ([^[:space:]]+) ]]; then
            branch=${BASH_REMATCH[1]}
        else
            branch="$(git describe --all --contains --abbrev=4 HEAD 2> /dev/null || echo HEAD)"
        fi

        # Determine the status of the files.
        local tag=""
        if [[ "$status" =~ Untracked\ files ]]; then
            tag=$tag"\[$RESET\]?"
        fi
        if [[ "$status" =~ Changes\ not\ staged\ for\ commit ]]; then
            tag=$tag"\[$BOLD$RED\]!"
        fi
        if [[ "$status" =~ Changes\ to\ be\ committed ]]; then
            tag=$tag"\[$BOLD$GREEN\]+"
        fi
        tag=$tag"\[$RESET\]"

        echo -n " on \[$BOLD$MAGENTA\]$branch$tag"
        return
    fi

    # Now check the svn status
    status=$(svn status 2>&1)
    if ! [[ "$status" =~ not\ a\ working\ copy ]]; then
        # Get the branch name.  I know the call to awk will slow things
        # down, but I don't know of another way to get the branch name
        # at the moment.
        branch=$(svn info | awk -F / '/URL/ {print $NF}')

        # Determine the status of the files.
        local flags=$(echo "$status" | cut -c 1)
        local tag=""
        if [[ "$flags" =~ "?" ]]; then
            tag=$tag"\[$RESET\]?"
        fi
        if [[ "$flags" =~ (C|X|\!|\~) ]]; then
            # svn only knows about commits waiting to happen.  So, we'll
            # use the red "!" to indicate problems.
            tag=$tag"\[$BOLD$RED\]!"
        fi
        if [[ "$flags" =~ (A|D|M|R) ]]; then
            tag=$tag"\[$GREEN\]+"
        fi
        tag=$tag"\[$RESET\]"

        echo -n " on \[$BOLD$CYAN\]$branch$tag"
        return
    fi
}

# And set my prompt.
_PS1="\n"$usr" at "$hst" in "$pth
export PROMPT_COMMAND='export PS1="${_PS1}$(repo_prompt)\n\$ "'

#--------1---------2---------3---------4---------5---------6---------7--
# Set some aliases
alias xvim='xterm -e vim'   # I don't like gVim and this is tolerable.
alias tmux='tmux -2'        # Force 256 colors in tmux.

# Colorize ls based on BSD vs. GNU
if [[ "$OS" = "darwin" ]]; then
    # Set the command line colors. Based on information from
    # osxdaily.com/2012/02/21/add-color-to-the-terminal-in-mac-os-x/
    export CLICOLOR=1
    export LSCOLORS=ExFxCxDaBxegedabagacad
else
    alias ls='ls --color=auto'
fi

# Totally stole the idea from jefflarkin
alias :q="echo \"Doh!  You're not in vi anymore.\""
alias :x="echo 'Hey smart guy, you already did that.'"
alias :e="echo \"Wouldn't it  be a good idea to open vi first?\""

#--------1---------2---------3---------4---------5---------6---------7--
# Set the X forwarding if we are using Windows as a client machine.
if [[ $OS = *cygwin* || $OS = *mingw* ]]; then
    export DISPLAY=:0
fi

