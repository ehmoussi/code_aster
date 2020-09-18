# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
# This file is part of code_aster.
#
# code_aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# code_aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------

import code_aster
from code_aster.Commands import *

code_aster.init("--test", "--continue")
# POURSUITE()

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
