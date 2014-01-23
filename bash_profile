#!/bin/bash
if [ -f $HOME/.bashrc ]; then
    source $HOME/.bashrc
fi

if [ -f $HOME/.local/bashrc ]; then
    source $HOME/.local/bashrc
fi

if [ -f $HOME/.profile ]; then
    source $HOME/.profile
fi
