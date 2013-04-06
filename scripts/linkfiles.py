#!/usr/bin/env python3
#--------1---------2---------3---------4---------5---------6---------7--
# A python script to create a backup and link the dot files. According
# to the Python 3 documentation, the symlink function in the OS module
# is supported on all platforms. So this should work.
#
# Keith Prussing 27 February 2013
#
#--------1---------2---------3---------4---------5---------6---------7--
# Define the files of interest.
import os
files = [ \
        "bash_profile",     \
        "bashrc",           \
        "tmux.conf",        \
        "profile",          \
        "vim",              \
        "vimrc",            \
        "scripts",          \
        "gitignore"         \
    ]

# Get the root directory of the dot files.
dotdir =  os.path.abspath( \
        os.path.dirname( os.path.realpath(__file__)) +os.sep +".." \
    )

# Back up a given file.
def link_file(fname):
    import shutil
    # Set the file name.
    oldfile = os.getenv("HOME") +os.sep +"." +fname
    newfile = dotdir +os.sep +fname
    # If the file is not one we have, quit.
    if not os.path.exists(newfile):
        raise ValueError(fname +" does not exist in " +dotdir)
    # Check for a file to backup
    if os.path.exists(oldfile):
        # Create the backup directory
        if not os.path.exists(dotdir +os.sep +"backup"):
            print("Creating backup directory...")
            os.mkdir(dotdir +os.sep +"backup")
            print("Done")
        # Move the file
        shutil.move(oldfile, dotdir +os.sep +"backup" +os.sep +fname)
    # Link the new file
    print("Creating the symlink " +newfile +" => " +oldfile +"...")
    if sys.version_info.minor > 2 or os.name == "nt":
        os.symlink(newfile, oldfile, os.path.isdir(newfile))
    else:
        os.symlink(newfile, oldfile)
    print("Done")
    return
# 

if __name__ == "__main__":
    import sys
    if len(sys.argv) < 2:
        lFiles = files
    else:
        lFiles = sys.argv[1:]
    for f in lFiles:
        try:
            link_file(f)
        except ValueError as err:
            print(err.args[0])
    #
#

