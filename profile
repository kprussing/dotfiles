# Add to the path ordered by preference
paths="
    /opt/local/bin
    /opt/local/sbin
    /opt/android-sdk-macosx/tools
    /opt/android-sdk-macosx/platform-tools
    $HOME/.scripts
    /nagfor/bin
    $HOME/.local/bin
    $HOME/.local/scripts"
for p in $paths; do
    if [[ -z "$BIN" ]]; then
        [ -d $p ] && BIN=$p
    else
        [ -d $p ] && BIN=$BIN:$p
    fi
done
# And set the path
if [[ ! -z "$BIN" ]]; then
    export PATH=$BIN:$PATH
fi

# Set the man path
paths="
    /usr/share/man
    /usr/local/man
    /opt/local/share/man
    /opt/X11/share/man
    $HOME/.local/man
    $HOME/.local/share/man
"
for p in $paths; do
    if [[ -z "$MANPATH" ]]; then
        [ -d $p ] && MANPATH=$p
    else
        [ -d $p ] && MANPATH=$MANPATH:$p
    fi
done
if [[ ! -z "$MANPATH" ]]; then
    export MANPATH
fi

# Set the library path
paths="
    /opt/OpenBLAS/lib
    $HOME/.local/lib
    $HOME/.local/lib64
"
for p in $paths; do
    if [[ -z "$LD_LIBRARY_PATH" ]]; then
        [ -d $p ] && LD_LIBRARY_PATH=$p
    else
        [ -d $p ] && LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$p
    fi
done
if [[ ! -z "$LD_LIBRARY_PATH" ]]; then
    export LD_LIBRARY_PATH
fi

# Set the pkgconfig path
paths="
    $HOME/.local/lib/pkgconfig
"
for p in $paths; do
    if [[ -z "$PKG_CONFIG_PATH" ]]; then
        [ -d $p ] && PKG_CONFIG_PATH=$p
    else
        [ -d $p ] && PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$p
    fi
done
if [[ ! -z "$PKG_CONFIG_PATH" ]]; then
    export PKG_CONFIG_PATH
fi

# Set a python development path
paths="$HOME/Documents/Development/python_dev"
for pp in $paths; do
    for p in $pp/*; do
        if [[ -z "$PYTHONPATH" ]]; then
            [ -d $p/build ] && PYTHONPATH=$p/build
        else
            [ -d $p/build ] && PYTHONPATH=$PYTHONPATH:$p/build
        fi
    done
done
if [[ ! -z "$PYTHONPATH" ]]; then
    export PYTHONPATH
fi

