import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

ACIER=DEFI_MATER_GC(
   ACIER=_F(E=2.0E+11, SY=500.0E+06, NU=0.30,
            D_SIGM_EPSI=2.E7,SIGM_LIM=4.545454545454545E8,EPSI_LIM=1.E-2,),
)

test.assertTrue( True )

FIN()
