import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

LISTE=DEFI_LIST_REEL(VALE=0.0);

TX=CREA_TABLE(LISTE=_F(LISTE_R=LISTE.getValuesAsArray(),PARA=('X')))

func = EXTR_TABLE(
        TYPE_RESU='FONCTION_SDASTER',
        TABLE=TX,
        NOM_PARA='X',)

test.assertTrue( True )

FIN()
