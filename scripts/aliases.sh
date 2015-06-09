# Put all of my aliases in one place.  This assumes the environment
# variable 'OS' has already been set.  This is relevant for getting
# colored output from `ls` on OS X.

alias xvim='xterm -e vim'   # I don't like gVim and this is tolerable.
alias tmux='tmux -2'        # Force 256 colors in tmux.

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

# Quick launch specific mailboxes in `mutt` for online reading.
alias pmutt="mutt -F ~/.mutt/personal/online.rc"
alias wmutt="mutt -F ~/.mutt/outlook/online.rc"

# Get todotxt to do the right thing.  Don't auto archive (-a), remove
# blank lines (-n), and prepend the date (-t).
alias todo="todotxt -ant"

# Use Steve Losh's `t`
alias t="python2.7 ~/.scripts/t/t.py --task-dir ~/Documents/Development/todo --list TODO.txt"

