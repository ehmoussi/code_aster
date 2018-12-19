import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("zzzz395e.mmed")

TEST_RESU(MAILLAGE = _F(MAILLAGE    = MA,
                        CARA        = 'NB_GROUP_MA',
                        REFERENCE   = 'ANALYTIQUE',
                        CRITERE     = 'ABSOLU',
                        VALE_REFE_I = 6,
                        VALE_CALC_I = 6,)
          )

FIN()
