#!/bin/zsh
# The function to establish a mercurial prompt.

function _hg_prompt() {
    local sta=$(hg status 2>&1 | cut -d ' ' -f 1 | tr -s '\n' ' ')
    if ! [[ "$sta" =~ 'abort:' || "$sta" =~ '_hg_prompt:' ]]; then
        # Make a hg prompt!
        local branch=$(hg branch -q)

        local tag
        if [[ "$sta" =~ "\?" ]]; then
            tag=$tag"%{$reset_color%}?"
        fi
        if [[ "$sta" =~ '(M|!)' ]]; then
            tag=$tag"%{$fg_bold[red]%}!"
        fi
        if [[ "$sta" =~ '(A|R)' ]]; then
            tag=$tag"%{$fg_bold[green]%}+"
        fi

        echo " on %{$fg_bold[green]%}$branch$tag%{$reset_color%}"
        true
    else
        # Otherwise, we aren't really in a hg repository or hg is not
        # installed.
        false
    fi
}

