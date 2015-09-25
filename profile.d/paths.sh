# This is simply and example of possible places to look for executables.
# It does not actually do anything.
return

paths="
    $HOME/.scripts
    $HOME/.local/bin
    $HOME/.local/scripts
    /opt/local/bin
    /opt/local/sbin
    /opt/android-sdk-macosx/tools
    /opt/android-sdk-macosx/platform-tools
    /nagfor/bin
”
for p in $paths; do
    if [[ $(echo "$1" | grep -q "$2") ]]; then
        BIN=$(path_append "$BIN" "$p")
    fi
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
”
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
”
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

