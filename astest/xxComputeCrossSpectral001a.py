# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

fsin = FORMULE(NOM_PARA='INST', VALE='sin(INST)')

interspec = CALC_INTE_SPEC(INST_INIT=0.,
                           INST_FIN=10,
                           DUREE_ANALYSE=1,
                           DUREE_DECALAGE=1,
                           NB_POIN=2*512,
                           FONCTION=fsin,
                          )

test.assertEqual(interspec.getType(), "INTERSPECTRE")

test.printSummary()

FIN()
