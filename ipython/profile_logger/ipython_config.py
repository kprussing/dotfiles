import glob, os

# Configure IPython for logging.
cnf = get_config()

# The default profile is the starting point.
load_subconfig("ipython_config.py", profile="default")

# Run all of the startup scripts for the default profile.
default_startup = os.path.realpath( os.path.join( \
        os.path.split(__file__)[0], os.pardir, \
        "profile_default", "startup" \
    ) )
cnf.InteractiveShellApp.exec_files = glob.glob( \
        os.path.join(default_startup, "*py") \
    )

