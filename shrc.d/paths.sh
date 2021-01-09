# This is simply and example of possible places to look for executables.
# It is a collection of all the places I have had to put executables.

paths=(
    /opt/local/Library/Frameworks/Python.framework/Versions/3.7/bin
    "/Applications/MacVim.app/Contents/bin"
    "/nagfor/bin"
    "/opt/android-sdk-macosx/platform-tools"
    "/opt/android-sdk-macosx/tools"
    "/opt/local/sbin"
    "/opt/local/bin"
    "$HOME/Library/Python/3.8/bin"
    "$HOME/.local/scripts"
    "$HOME/.local/bin"
    "$HOME/.scripts"
)
for p in ${paths[@]}; do
    PATH=`path_prepend "$PATH" "$p"`
done
if ! test -z "$PATH"
then
    export PATH
fi

# For some reason, the man path is not updated correctly by default.  To
# be fair, I no longer remember which system is the culprit.  I know
# installing to my home directory messes things up.
paths=(
    "/usr/share/man"
    "/usr/local/man"
    "/usr/local/share/man"
    "/opt/local/share/man"
    "/opt/local/Library/Frameworks/Python.framework/Versions/Current/man"
    "/opt/X11/share/man"
    "$HOME/.local/man"
    "$HOME/.local/share/man"
)
for p in ${paths[@]}; do
    MANPATH=`path_append "$MANPATH" "$p"`
done
if ! test -z "$MANPATH"
then
    export MANPATH
fi

# Update the library path for building in my home directory.  While
# we're at it, we might as well check the package configuration too.
paths=(
    "$HOME/.local/lib"
    "$HOME/.local/lib64"
)
for p in ${paths[@]}; do
    LD_LIBRARY_PATH=`path_append "$LD_LIBRARY_PATH" "$p"`
    PKG_CONFIG_PATH=`path_append "$PKG_CONFIG_PATH" "$p"/pkgconfig`
done
unset -v paths
if ! test -z "$LD_LIBRARY_PATH"
then
    export LD_LIBRARY_PATH
fi
if ! test -z "$PKG_CONFIG_PATH"
then
    export PKG_CONFIG_PATH
fi

