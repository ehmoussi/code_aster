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

code_aster.init("--test")

one = 1

def SIYYp(x,y,z):
    a0 =  2.0 ; ax = -1.0 ; ay = -3.0 ; az =  1.0
    return (a0 + ax*x + ay*y + az*z)*1.0E+6

SIYY = FORMULE(VALE='SIYYp(X,Y,Z)',
               SIYYp=SIYYp,
               NOM_PARA=['X', 'Y', 'Z'],)

func = DEFI_FONCTION(VALE=(0, 0, 1, 1), NOM_PARA='X')

test.assertEqual(SIYY(0, 0, 0), 2.0e6)

code_aster.saveObjects()

test.printSummary()

FIN()
