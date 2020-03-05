# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init("--continue")
# POURSUITE()

test = code_aster.TestCase()

# 'mesh' has been deleted
with test.assertRaises(NameError):
    mesh

# 'coord' has been deleted: not yet supported
with test.assertRaises(NameError):
    coord

test.assertTrue(mesh2.hasGroupOfCells("Tout"))
test.assertFalse(mesh2.hasGroupOfNodes("Tout"))
test.assertFalse(mesh2.hasGroupOfCells("POINT"))
test.assertTrue(mesh2.hasGroupOfNodes("POINT"))

support = model.getMesh()
test.assertIsNotNone(support)

test.printSummary()

FIN()
