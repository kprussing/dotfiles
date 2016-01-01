# Set all of the completion details.

autoload -U compinit
compinit

# Use colors!

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
#zstyle ':completion:*:*:kill:*:processes' list-colors \
    #'=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:kill:*' list-colors '=%*=01;31'

zstyle ':completion:*' menu select=1 # Navigate the menu for options.

