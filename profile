# Add to the path ordered by preference
paths="
    /opt/local/bin                          # macports
    /opt/local/sbin                         # macports
    /opt/android-sdk-macosx/tools
    /opt/android-sdk-macosx/platform-tools
    $HOME/.scripts
    $HOME/usr/bin
    $PYTHON3DIR                             # Windows python path
    /nagfor/bin                             # MinGW mount point
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

#--------1---------2---------3---------4---------5---------6---------7--
# Below is my origin from home.
# My path variables
#PATH=$PATH:~/scripts

# Add android SDK to path
#PATH=$PATH:/opt/android-sdk-macosx/tools
#PATH=$PATH:/opt/android-sdk-macosx/platform-tools
##
# Your previous /Users/keith/.profile file was backed up as /Users/keith/.profile.macports-saved_2012-06-21_at_20:33:52
##

# MacPorts Installer addition on 2012-06-21_at_20:33:52: adding an appropriate PATH variable for use with MacPorts.
#export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

# Add the man path for nagfor
#if [[ -z $MANPATH ]]; then
    #MANPATH=/usr/local/man
#else
    #MANPATH=$MANPATH:/usr/local/man
#fi
#MANPATH=$MANPATH:/opt/local/share/man
#MANPATH=$MANPATH:/opt/X11/share/man
#MANPATH=/usr/share/man:$MANPATH
#export MANPATH

