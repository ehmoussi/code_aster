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

test = code_aster.TestCase()

code_aster.init()

func = [None, None]

func[0] = DEFI_FONCTION(VALE=(0, 0, 1, 1), NOM_PARA='X')
func[1] = DEFI_FONCTION(VALE=(0, 0, 1, 2), NOM_PARA='X')

test.assertEqual(func[0](1), 1)
test.assertEqual(func[1](1), 2)

results = dict(
    one=DEFI_FONCTION(VALE=(0, 0, 1, 1), NOM_PARA='X'),
    two=DEFI_FONCTION(VALE=(0, 0, 1, 2), NOM_PARA='X')
)

test.assertEqual(results["one"](1), 1)
test.assertEqual(results["two"](1), 2)

tup = tuple(func)

code_aster.saveObjects()

test.printSummary()

FIN()
