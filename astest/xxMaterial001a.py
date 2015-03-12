
import code_aster
from code_aster.Commands import *

MATER2 = DEFI_MATERIAU( ELAS = _F( E = 220000.,
                                   NU = 0.33,
                                   ALPHA = 16.E-6,
                                   RHO = 8300., ), )

MATER2.debugPrint()
