#!/bin/zsh
# My zsh configuration.  You may be wondering why I don't use oh-my-zsh
# or prezto.  It's because I only want the vi mode plug in and I want to
# use my repository prompts.  That, and oh-my-zsh was taking to long to
# load.

# Use vi mode
bindkey -v

# Initialize the colors
autoload -U colors && colors

# Let the prompt actually expand functions.
setopt PROMPT_SUBST

for config in "$HOME"/.zshrc.d/*zsh
do
    source $config
done
unset -v config

if [ -f "$HOME"/.local/zshrc ]; then
    source "$HOME"/.local/zshrc
fi

