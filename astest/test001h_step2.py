# coding: utf-8

import code_aster
from code_aster.Commands import *

POURSUITE()

test = code_aster.TestCase()

# 'mesh' has been deleted
with test.assertRaises(NameError):
    mesh

# 'coord' has been deleted: not yet supported
with test.assertRaises(NameError):
    coord

test.assertTrue(mesh2.hasGroupOfElements("Tout"))
test.assertFalse(mesh2.hasGroupOfNodes("Tout"))
test.assertFalse(mesh2.hasGroupOfElements("POINT"))
test.assertTrue(mesh2.hasGroupOfNodes("POINT"))

support = model.getMesh()
test.assertIsNotNone(support)

test.printSummary()

FIN()
