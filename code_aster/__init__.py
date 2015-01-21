# code_aster cython package

# discourage import *
__all__ = []

from code_aster.RunManager import Initializer

# Automatically call `asterInitialization()` at import
mode = 0
try:
    from aster_init_options import options
except ImportError:
    options = ['']

if 'CATAELEM' in options:
    print "starting with mode = 1 (build CATAELEM)..."
    mode = 1

if 'MANUAL' not in options:
    Initializer.init( mode )

    import atexit
    atexit.register( Initializer.finalize )

# import datastructures
from code_aster.Mesh.Mesh import Mesh
from code_aster.Modeling.Model import Model
from code_aster.Modeling.Model import Mechanics, Thermal, Acoustics
from code_aster.Modeling.Model import Axisymmetrical, Tridimensional, Planar, DKT
from code_aster.DataFields.FieldOnNodes import FieldOnNodesDouble
from code_aster.Function.Function import Function


del mode
del options
