# Set up my prompt.  It's big and extravagant, but I like it!

if [[ $- != *i* ]]; then
    return
fi

# Ensure that the colors have been sourced.  Note that this assumes the
# colors script exists.

if [[ ! -z "$RED" ]]; then
    source "$HOME"/.bashrc.d/colors.bash
fi

# First, check to see if the user is root.
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
elif [[ "$OS" = *cygwin* || "$OS" = *mingw* ]]; then
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
    if ! [[ "$status" =~ Not\ a\ git\ repository || "$status" =~ not\ found ]]; then
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
        if [[ "$status" =~ Changed\ but\ not\ updated ]]; then
            tag=$tag"\[$BOLD$RED\]!"
        fi
        if [[ "$status" =~ Changes\ to\ be\ committed ]]; then
            tag=$tag"\[$BOLD$GREEN\]+"
        fi
        tag=$tag"\[$RESET\]"

        echo -n " on \[$BOLD$MAGENTA\]$branch$tag"
    fi

    status=$(hg status 2>&1)
    if ! [[ "$status" =~ abort:\ no\ repository\ found || "$status" =~ not\ found ]]; then
        branch=$(hg branch -q)

        # Determine the status of the files.
        local flags=$(hg status 2>&1 | cut -c 1)
        local tag=""
        if [[ "$flags" =~ "?" ]]; then
            tag="\[$RESET\]?"
        fi
        if [[ "$flags" =~ (M|\!) ]]; then
            tag=$tag"\[$BOLD$RED\]!"
        fi
        if [[ "$flags" =~ (A|R) ]]; then
            tag=$tag"\[$BOLD$GREEN\]+"
        fi
        tag=$tag"\[$RESET\]"

        echo -n " on \[$BOLD$GREEN\]$branch$tag"
    fi

    # Now check the svn status
    status=$(svn status 2>&1)
    if ! [[ "$status" =~ not\ a\ working\ copy || "$status" =~ not\ found  ]]; then
        # Get the branch name.  I know the call to awk will slow things
        # down, but I don't know of another way to get the branch name
        # at the moment.
        branch=$(svn info | awk -F / '/^URL/ {print $NF}')

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
    fi
}

# And set my prompt.
_PS1="\n"$usr" at "$hst" in "$pth
export PROMPT_COMMAND='export PS1="${_PS1}$(repo_prompt)\n\$ "'

