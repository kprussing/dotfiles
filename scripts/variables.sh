# Define shell independent variables in one location.

# Determine the operating system
OS=$(uname | tr A-Z a-z)

# Set my editor and pager
export EDITOR=vim
export VISUAL=$EDITOR
export PAGER=less

export LESS="-i -g -R"

# Point the temp directory to something I own.  This helps with long
# running tmux sessions.
#export TMPDIR=$HOME/.local/tmp

# Also hard set the Tex directory
export TEXMFHOME=$HOME/.texmf

# Set the X forwarding if we are using Windows as a client machine.
if [[ $OS = *cygwin* || $OS = *mingw* ]]; then
    export DISPLAY=:0
fi

