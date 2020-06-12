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

test.assertTrue("Tout" in mesh2.getGroupsOfCells())
test.assertTrue("Tout" not in mesh2.getGroupsOfNodes())
test.assertTrue("POINT" not in mesh2.getGroupsOfCells())
test.assertTrue("POINT" in mesh2.getGroupsOfNodes())

support = model.getMesh()
test.assertIsNotNone(support)

test.printSummary()

FIN()
