#!/usr/bin/env python
# Define a bunch of useful functions
class myfuncs:
    """
    Define all of my functions within a class to keep the global name
    space clean.
    """

    @staticmethod
    def qp(F, V):
        """
        Quickly plot a surface defined by a face and vertex list, F and
        V respectively.  The faces are colored blue.  This is simply a
        rewrite of Ken's qp in MATLAB.

        F   : Nx3 NumPy array of faces      (V1, V2, V3)
        V   : Nx3 NumPy array of vertexes   ( X,  Y,  Z)
        """
        import matplotlib.pyplot
        from mpl_toolkits.mplot3d import Axes3D
        #
        # Plot the surface
        fig = matplotlib.pyplot.figure()
        axs = fig.add_subplot(1,1,1, projection="3d")
        axs.plot_trisurf(V[:,0], V[:,1], V[:,2], triangles=F)
        #
        # Label the axes and set them equal
        axs.set_xlabel("x")
        axs.set_ylabel("y")
        axs.set_zlabel("z")
        axs.axis("equal")
        #
        # And show the figure
        matplotlib.pyplot.show()
        return fig
    # end def qp

    @staticmethod
    def reload(mod):
        """
        Given a module, add tracking information to the module and log
        the changes.  This will facilitate knowing what version of 
        module was used during development.
        """
        import difflib, imp, logging
        # Set the logger
        logger = logging.getLogger("myfuncs.reload")
        logger.addHandler( logging.NullHandler() )
        logger.setLevel( logging.DEBUG )
        #
        if "__track_source__" in mod.__dict__:
            orig = mod.__track_source__
        else:
            orig = None
        # end if
        #
        # Read the source file in its current state.
        with open(mod.__file__, "r") as fid:
            mod.__track_source__ = fid.readlines()
        # end with
        #
        # Check for differences and report any changes.
        logger.debug(__file__)
        if orig is None:
            for it in range(len(mod.__track_source__)):
                logger.debug("{:d} {:s}".format( \
                        it+1, mod.__track_source__[it].rstrip() \
                    ) )
            # end for
        else:
            diffs = difflib.unified_diff( \
                    orig, mod.__track_source__, \
                    fromfile="Original", tofile="Updated" \
                )
            for line in diffs:
                logger.debug(line.rstrip())
            # end for
        # end if
        return imp.reload(mod)
    # end def reload

# end class myfuncs

