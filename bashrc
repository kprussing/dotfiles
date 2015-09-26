if [[ $- != *i* ]]; then
    return
fi

# We begin with the general settings.  Tell bash to check the window
# size after each command.
shopt -s checkwinsize

# Use vi bindings for bash
set -o vi

# Source the other settings
for config in "$HOME"/.bashrc.d/*.bash;
do
    source $config
done
unset -v config

# Source the local setting too.
if [ -f $HOME/.local/bashrc ]; then
    source $HOME/.local/bashrc
fi

