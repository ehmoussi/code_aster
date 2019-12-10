# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

PRE_IDEAS(UNITE_IDEAS=62,UNITE_MAILLAGE=22)

MA22=LIRE_MAILLAGE(FORMAT="ASTER",UNITE=22)

test.assertEqual(MA22.getType(),"MAILLAGE_SDASTER")

test.printSummary()

FIN()
