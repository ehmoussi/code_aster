# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

list_r = DEFI_LIST_REEL(DEBUT=0.,
                        INTERVALLE=(_F(JUSQU_A=1.0, PAS=0.1),))

list_values = list_r.getValues()
for j in range(len(list_values)):
    test.assertAlmostEqual(list_values[j], j*0.1)

test.assertEqual(list_r.getType(), "LISTR8_SDASTER")


list_inst =DEFI_LIST_INST(DEFI_LIST=_F(LIST_INST=list_r),)

test.assertEqual(list_inst.getType(), "LIST_INST")

test.printSummary()

FIN()
