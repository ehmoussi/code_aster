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

code_aster.init("--test")

test = code_aster.TestCase()

table = LIRE_TABLE(UNITE=31, FORMAT='TABLEAU')

pytab = table.EXTR_TABLE()
test.assertSequenceEqual(list(pytab.GAMMA.values()), [None, 1.5, 2.5, None, -3.4])

IMPR_TABLE(UNITE=88, TABLE=table)
IMPR_TABLE(UNITE=6, TABLE=table)

test.printSummary()

FIN()
