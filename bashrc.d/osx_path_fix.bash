#!/bin/bash
# Fix the mess OSX and path_helper make of the path.  These tools
# "conveniently help" by putting the /usr paths at the front.  The
# problem with that is *I don't want that*!  The /opt and $HOME
# directories are supposed to take precedence.
#
# NOTE: This is a simple copy of the zsh version.  The only difference
# is how the PATH variable is tokenized.  I can't seem to figure out how
# to make both bash and zsh happy.

if ! [[ $OS = "darwin" ]]; then
    # This only happens on OSX (I think...)
    return
fi

front=""
end=""
paths=$(echo $PATH | tr ':' "\n")
for pp in ${paths[@]}
do
    #echo $pp
    if [[ $pp =~ ^(/usr|/s?bin|/opt/X11/bin) ]]
    then
        #echo Add "'"$pp"'" to end
        if [[ -z "$end" ]]
        then
            end="$pp"
        else
            end="$end":"$pp"
        fi
    else
        #echo Add "'"$pp"'" to front
        if [[ -z "$front" ]]
        then
            front="$pp"
        else
            front="$front":"$pp"
        fi
    fi
done
#echo $front
#echo $end
#echo "$front":"$end"
export PATH="$front":"$end"

