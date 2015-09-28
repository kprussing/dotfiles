#!/bin/zsh
# This is the adaptation of my bash prompt translated to zsh.
if [ $EUID -eq "0" ]; then
    # Annoy the #@!$ out of me.  Cyan seems to give the best contrast.
    usr="%K{red}%F{cyan}%n%f%k"
else
    # Green is best!
    usr="%{$fg_bold[green]%}%n%{$reset_color%}"
fi

# Determine the host and set the host and path colors
if [ "$SSH_TTY" ]; then
    # Use green and blue if we are using ssh.
    hst="%{$fg_bold[green]%}%m%{$reset_color%}"
    pth="%{$fg_bold[blue]%}%2~%{$reset_color%}"
elif [[ "$OS" = "darwin" ]]; then
    # I like magenta on the man page theme with a blue path.
    hst="%{$fg_bold[magenta]%}%m%{$reset_color%}"
    pth="%{$fg_bold[blue]%}%2~%{$reset_color%}"
elif [[ "$OS" = *cygwin* || "$OS" = *mingw* ]]; then
    # Let's try cyan with yellow for Windows.
    hst="%{$fg_bold[cyan]%}%m%{$reset_color%}"
    pth="%{$fg_bold[yellow]%}%2~%{$reset_color%}"
else
    # And no color is the default.
    hst="%m"
    pth="%2~"
fi

PROMPT='
$usr at $hst in $pth$(_repo_prompt)
%# '

MODE_INDICATOR="%{$fg[green]%}!%{$reset_color%}"

RPROMPT='$(vi_mode_prompt_info) %D{%F %T} %{%(?.$fg[green]✔.$fg[red]✘)%1G%}%{$reset_color%}'

