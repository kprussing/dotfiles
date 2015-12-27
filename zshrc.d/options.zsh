# Set the options.  This collects all of my options into one place.  I
# may break this out into higher specification files, but not yet.

# If the pattern is bad, shut up and  pass it to the command and let it
# sort it all out.  This is especially true for using `port`.

setopt no_nomatch
setopt no_badpattern

# Make history work nicely.

setopt append_history           # Yes, save the history,
setopt inc_append_history       # write it straight away,
setopt share_history            # and all terminals can see it.
setopt hist_ignore_dups         # Don't store repeated lines.
setopt hist_expire_dups_first   # Dump duplicates first.
setopt hist_find_no_dups        # Skip it if I already skipped it.
setopt hist_reduce_blanks       # Remove superfluous white space.
setopt hist_ignore_space        # Ignore lines starting with a space.
setopt hist_no_store            # Ignore me searching my history.
setopt hist_no_functions        # Proper functions go in a file.
setopt hist_verify              # Verify the history expansion before
                                # execution.
# Completions

setopt auto_list            # Show a list on ambiguous completion.
setopt no_menu_complete     # Don't automatically insert a completion.
setopt no_auto_remove_slash # Leave the slash.  I'm used to it.
setopt complete_in_word     # Yes, complete a word I'm in the middle of.
setopt always_to_end        # And just go to the end of the word once 
                            # I'm done.

# Miscellaneous

setopt extended_glob            # Use better REGEX for globbing
setopt no_correct               # Type the command you want.
setopt no_correct_all           # Seriously, you can't put that in a script.
setopt prompt_subst             # The prompt can expand functions.

