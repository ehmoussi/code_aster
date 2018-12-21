import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

LISTE=DEFI_LIST_REEL(VALE=1.0)

TX=CREA_TABLE(LISTE=_F(LISTE_R=LISTE.getValuesAsArray(),PARA=('X')))

IMPR_TABLE(TABLE=TX)

TEST_TABLE(REFERENCE='ANALYTIQUE',
           VALE_CALC=1.0,
           VALE_REFE=1.0,
           NOM_PARA='X',
           TABLE=TX,
           )

FIN()
