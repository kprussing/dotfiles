# The things that tell the world about me!  We begin with setting some
# universal variables starting with the operating system.

echo "Profile running"

export OS=$(uname | tr A-Z a-z)

# Next the editor and pager
export EDITOR=vim
export VISUAL=$EDITOR
export PAGER=less

# And set the TeX directory to the proper value.

export TEXMFHOME=$HOME/.texmf

# Set the X forwarding if we are using Windows as a client machine.

if [[ $OS = *cygwin* || $OS = *mingw* ]]; then
    export DISPLAY=:0
fi

# Now source all of the additional configurations.

for config in "$HOME"/.profile.d/*.sh
do
    . $config
done
unset -v config

# vim: set filetype=rc

