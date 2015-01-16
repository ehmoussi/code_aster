# code_aster cython package

# import code_aster.RunManager.Initializer as libInit

# Automatically call `asterInitialization()` at import
mode = 0
try:
    from aster_init_options import options
except ImportError:
    options = ['MANUAL']

if 'CATAELEM' in options:
    print "starting with mode = 1 (build CATAELEM)..."
    mode = 1

if 'MANUAL' not in options:
    libInit.asterInitialization( mode )

    import atexit
    atexit.register( libInit.asterFinalization )

from code_aster.Mesh.Mesh import Mesh
from code_aster.Function.Function import Function
