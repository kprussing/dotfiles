#!/bin/zsh
# Define the function to establish the git prompt.

function _git_prompt() {
    local sta="$(git status -unormal 2>&1)"
    if ! [[ "$sta" =~ '[Nn]ot a git repository' || "$sta" =~ 'not found' ]]; then
        # If we have git and we are in a repository, form a prompt!
        # First, get the branch name.
        local branch
        if [[ '$sta' =~ 'On branch [^[:space:]]' ]]; then
            branch=$match[1]
        else
            # Or figure out what happened when it blew up…
            branch="$(git describe --all --contains --abbrev=4 HEAD 2> /dev/null || echo HEAD)"
        fi

        local tag
        if [[ "$sta" =~ 'Untracked files' ]]; then
            tag=$tag"%{$reset_color%}?"
        fi
        if [[ "$sta" =~ 'Changes not staged for commit' ]]; then
            tag=$tag"%{$fg_bold[red]%}!"
        fi
        if [[ "$sta" =~ 'Changed but not updated' ]]; then
            tag=$tag"%{$fg_bold[red]%}!"
        fi
        if [[ "$sta" =~ 'Changes to be committed' ]]; then
            tag=$tag"%{$fg_bold[green]%}+"
        fi
        echo " on %{$fg_bold[magenta]%}$branch$tag%{$reset_color%}"
        true
    else
        # Otherwise, we aren't really in a git repository or git is not
        # installed.
        false
    fi
}

