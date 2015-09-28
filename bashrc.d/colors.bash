# Set some easy references to the color.
if [[ $- != *i* ]]; then
    return
fi

# Make the colors clear
BLACK='\e[30m'
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
MAGENTA='\e[35m'
CYAN='\e[36m'
WHITE='\e[37m'

# Next, the background
BGBLACK='\e[40m'
BGRED='\e[41m'
BGGREEN='\e[42m'
BGYELLOW='\e[43m'
BGBLUE='\e[44m'
BGMAGENTA='\e[45m'
BGCYAN='\e[46m'
BGWHITE='\e[47m'

# Modifiers
RESET='\e[0m'
BOLD='\e[1m'
UNDERLINE='\e[4m'
BLINK='\e[5m'

