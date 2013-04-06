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

# Now we handle the path variables.  The order of the lists below are in
# descending preference.  The path variable is prepended; while, the
# rest are appended to the appropriate variable.
#paths="
    #$HOME/.local/bin
    #$HOME/.local/scripts
    #$HOME/.scripts
    #/opt/local/bin
    #/opt/local/sbin
    #/opt/android-sdk-macosx/tools
    #/opt/android-sdk-macosx/platform-tools
    #/nagfor/bin
#"
#for p in $paths; do
    #if [[ -z "$BIN" ]]; then
        #[ -d $p ] && BIN=$p
    #else
        #[ -d $p ] && BIN=$BIN:$p
    #fi
#done
#if [[ ! -z "$BIN" ]]; then
    #export PATH=$BIN:$PATH
#fi

# The man page path
#paths="
    #/usr/share/man
    #/usr/local/man
    #/opt/local/share/man
    #/opt/X11/share/man
    #$HOME/.local/man
    #$HOME/.local/share/man
#"
#for p in $paths; do
    #if [[ -z "$MANPATH" ]]; then
        #[ -d $p ] && MANPATH=$p
    #else
        #[ -d $p ] && MANPATH=$MANPATH:$p
    #fi
#done
#if [[ ! -z "$MANPATH" ]]; then
    #export MANPATH
#fi

# Next the library path
#paths="
    #/opt/OpenBLAS/lib
    #$HOME/.local/lib
    #$HOME/.local/lib64
#"
#for p in $paths; do
    #if [[ -z "$LD_LIBRARY_PATH" ]]; then
        #[ -d $p ] && LD_LIBRARY_PATH=$p
    #else
        #[ -d $p ] && LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$p
    #fi
#done
#if [[ ! -z "$LD_LIBRARY_PATH" ]]; then
    #export LD_LIBRARY_PATH
#fi

# Next the pkg-config path
#paths="
    #$HOME/.local/lib/pkgconfig
#"
#for p in $paths; do
        #if [[ -z "$PKG_CONFIG_PATH" ]]; then
            #[ -d $p ] && PKG_CONFIG_PATH=$p
        #else
            #[ -d $p ] && PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$p
        #fi
#done
#if [[ ! -z "$PKG_CONFIG_PATH" ]]; then
    #export PKG_CONFIG_PATH
#fi

# And set the python development path.  This might need some tweaking
# still...
#paths="
    #$HOME/Documents/Development/python_dev
#"
#for dd in $paths; do
    #for pp in $dd/*; do
        #p=$pp/build/lib
        #if [[ -z "$PYTHONPATH" ]]; then
            #[ -d $p ] && PYTHONPATH=$p
        #else
            #[ -d $p ] && PYTHONPATH=$PYTHONPATH:$p
        #fi
    #done
#done
#if [[ ! -z "$PYTHONPATH" ]]; then
    #export PYTHONPATH
#fi

