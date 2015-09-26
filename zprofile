#!/bin/zsh
# Just source the real profile.
if [ -f "$HOME"/.profile ]; then
    source "$HOME"/.profile
fi

if [ -f "$HOME"/.local/zprofile ]; then
    source "$HOME"/.local/zprofile
fi

