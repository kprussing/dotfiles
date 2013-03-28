# Add to the path ordered by preference
paths="
    /opt/local/bin                          # macports
    /opt/local/sbin                         # macports
    /opt/android-sdk-macosx/tools
    /opt/android-sdk-macosx/platform-tools
    $HOME/.scripts
    $HOME/usr/bin
    /nagfor/bin                             # MinGW mount point
    $HOME/.local/scripts
"
for p in $paths; do
    [ -d $p ] && BIN=$BIN:$p
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
    $HOME/usr/man
    $HOME/usr/share/man
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
    $HOME/usr/opt/OpenBLAS/lib
    $HOME/usr/lib
    $HOME/usr/lib64
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
    $HOME/usr/lib/pkgconfig
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

