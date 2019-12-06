# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

PRE_GMSH(UNITE_GMSH=60,UNITE_MAILLAGE=22)

test.assertTrue( True )
test.printSummary()

FIN()
