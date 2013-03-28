#!/usr/bin/env python3
#--------1---------2---------3---------4---------5---------6---------7--
# A script to install and update bundles for vim.  It assumes that
# pathogen.vim is installed and used.  Bundles are placed in
# ~/.vim/bundle.
#
# Keith Prussing 25 February 2013
#
#--------1---------2---------3---------4---------5---------6---------7--
# Define the desired bundles
import os
bundles = { \
        "vim-latex" : "git://vim-latex.git.sourceforge.net/gitroot/vim-latex/vim-latex", \
        "nerdcommenter" : "git://github.com/scrooloose/nerdcommenter.git" \
    }
bundledir = os.getenv("HOME") +os.sep +".vim" +os.sep +"bundle"
if not os.path.exists(bundledir):
    os.mkdir(bundledir)

# Define a method to install a given bundle.
def install(bundle):
    import subprocess
    if os.path.exists(bundledir +os.sep +bundle):
        raise ValueError(bundle +" is already installed! Try updating.")
    # Save the current working directory.
    pwd = os.path.abspath(os.curdir)
    # Change to the bundle directory
    os.chdir(bundledir)
    print("Installing " +bundle +"...")
    ret = subprocess.call(["git", "clone", bundles[bundle], bundle])
    print("Done!")
    os.chdir(pwd)
    return ret

# Define a method to update the give bundle.
def update(bundle):
    import subprocess
    if not os.path.exists(bundledir +os.sep +bundle):
        raise ValueError(bundle +" is not installed! Try installing.")
    # Save the current working directory.
    pwd = os.path.abspath(os.curdir)
    # Change to the bundle directory
    os.chdir(bundledir +os.sep +bundle)
    print("Updating " +bundle +"...")
    ret = subprocess.call(["git", "pull"])
    print("Done")
    os.chdir(pwd)
    return ret

def pathogen():
    import subprocess
    autoload = os.path.abspath( \
            bundledir +os.sep +".." +os.sep + "autoload" \
        )
    if not os.path.exists(autoload):
        os.mkdir(autoload)
    if os.path.exists(autoload +os.sep +"pathogen.vim"):
        return 
    print("Installing pathogen...")
    ret = subprocess.call( [ \
            "curl", "-o", autoload+os.sep+"pathogen.vim", \
            "https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim" \
        ] )
    print("Done")
    return ret

if __name__ == "__main__":
    import sys
    if len(sys.argv) < 2:
        print("The command to perform must be included!")
        sys.exit(1)
    else:
        cmd = sys.argv[1]
    if len(sys.argv) < 3:
        lBundles = list( bundles.keys() )
    else:
        lBundles = sys.argv[2:]
    pathogen()
    for bundle in lBundles:
        if bundle not in bundles.keys():
            print("Unknown bundle " +bundle +" passed in! Skipping.")
            print("To add the bundle edit the vim_bundles.py script.")
            continue
        try:
            if cmd.lower() == "install":
                install(bundle)
            elif cmd.lower() == "update":
                update(bundle)
            else:
                print("Unknown command " +cmd +" provided")
                sys.exit(1)
        except ValueError as err:
            print(err.args[0])

