# This is simply and example of possible places to look for executables.
# It is a collection of all the places I have had to put executables.

paths=(
    "/opt/local/bin"
    "/opt/local/sbin"
    "$HOME/.scripts"
    "$HOME/.cabal/bin"
    "$HOME/.local/bin"
    "$HOME/.local/scripts"
    "$HOME/Library/Python/3.4/bin"
    "/opt/android-sdk-macosx/tools"
    "/opt/android-sdk-macosx/platform-tools"
    "/nagfor/bin"
)
for p in ${paths[@]}; do
    if ! echo "$PATH" | grep -q "$p" ; then
        BIN=$(path_append "$BIN" "$p")
    fi
done
unset -v BIN

# For some reason, the man path is not updated correctly by default.  To
# be fair, I no longer remember which system is the culprit.  I know
# installing to my home directory messes things up.
paths=(
    "/usr/share/man"
    "/usr/local/man"
    "/opt/local/share/man"
    "/opt/X11/share/man"
    "$HOME/.local/man"
    "$HOME/.local/share/man"
)
for p in ${paths[@]}; do
    MANPATH=$(path_append "$MANPATH" "$p")
done

# Update the library path for building in my home directory.  While
# we're at it, we might as well check the package configuration too.
paths=(
    "$HOME/.local/lib"
    "$HOME/.local/lib64"
)
for p in ${paths[@]}; do
    LD_LIBRARY_PATH=$(path_append "$LD_LIBRARY_PATH" "$p")
    PKG_CONFIG_PATH=$(path_append "$PKG_CONFIG_PATH" "$p"/pkgconfig)
done
unset -v paths

