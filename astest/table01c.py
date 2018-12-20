# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

table = LIRE_TABLE(UNITE=31, FORMAT='TABLEAU')

pytab = table.EXTR_TABLE()
test.assertSequenceEqual(pytab.GAMMA.values(), [None, 1.5, 2.5, None, 3.5])

IMPR_TABLE(UNITE=88, TABLE=table)
IMPR_TABLE(UNITE=6, TABLE=table)

test.printSummary()

FIN()
