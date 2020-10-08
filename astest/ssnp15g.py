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

# unittest for 'ListOfTables' object and its 'getTable()' accessor
import code_aster
from code_aster.Commands import *

code_aster.init("--test", "--continue")

test = code_aster.TestCase()

tab = U2.getTable("undefined-tab-name")
test.assertIsNone(tab)

INST_C2 = RECU_TABLE(CO=U2, NOM_TABLE='PARA_CALC')

IMPR_TABLE(TABLE=INST_C2,
           NOM_PARA='INST')

PARA_C2 = U2.getTable("PARA_CALC")
test.assertIsNotNone(PARA_C2)

# compare INST_C2 vs PARA_C2
tab1 = INST_C2.EXTR_TABLE()
tab2 = PARA_C2.EXTR_TABLE()
test.assertTrue(len(tab1) == len(tab2))
test.assertEqual(tab1.INST.values(), tab2.INST.values())

test.printSummary()

code_aster.close()
