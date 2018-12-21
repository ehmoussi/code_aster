import code_aster
from code_aster.Supervis import ExecutionParameter, Options
from code_aster.Commands import *

ExecutionParameter().enable(Options.StrictUnpickling)

POURSUITE()

test = code_aster.TestCase()

SOLU1=RESOUDRE(MATR=MATAS1, CHAM_NO=SECM1, CHAM_CINE=VCINE1,)

PRODUIT1=PROD_MATR_CHAM(MATR_ASSE=MATAS1, CHAM_NO=SOLU1,)

test.assertTrue( True )

FIN()
