# Collect my utility functions in one place.

function path_append () {
    # Append a path ($2) to a variable ($1) if it is not already in the
    # variable and exists.
    if [[ -z "$1" ]]; then
        # If the string is uninitialized, just create the path
        [ -d $2 ] && echo $2
    else
        # Check for duplicate paths.
        if echo $1 | grep -q "$2"; then
            echo $1
        else
            [ -d $2 ] && echo $1:$2 || echo $1
        fi
    fi
    return
}

function path_remove () {
    # Remove a path ($2) from a variable ($1) if it occurs in the path.
    # Don't forget to clean up those ugly duplicate colons.
    echo $1 | sed -e "s|$2||" -e "s|::|:|"
    return
}

