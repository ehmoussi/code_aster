import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MAT1=DEFI_MATERIAU(ELAS_ORTH=_F(  E_L = 2.0E+5,    E_T = 2.0E+5,
 NU_LT = 0.3, G_LT = 7.69231E+4,   G_LN = 7.69231E+4,   G_TN = 7.69231E+4,
           RHO = 8.E-6, ALPHA_L = 1.E-05,     ALPHA_T = 1.E-05))

MAT=DEFI_COMPOSITE(COUCHE=(
            _F(  EPAIS = 0.5,  MATER = MAT1,  ORIENTATION = 0.),
            _F(  EPAIS = 0.5,  MATER = MAT1,  ORIENTATION = 0.)) )

test.assertTrue( True )

FIN()
