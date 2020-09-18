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

MA = code_aster.Mesh()
MA.readAsterFile("xxElementaryCharacteristics001a.mail")

BETON=DEFI_MATERIAU(ELAS=_F(E = 1.E9,NU = 0.3,),)

MATAF=AFFE_MATERIAU(MAILLAGE=MA,
                    AFFE=(_F(GROUP_MA = 'MAI1',
                             MATER = BETON,)))

LEMOD=AFFE_MODELE(MAILLAGE=MA,
                  AFFE=(_F(GROUP_MA = 'MAI1',
                           PHENOMENE = 'MECANIQUE',
                           MODELISATION = 'DKTG',)))


LACAR=AFFE_CARA_ELEM(MODELE=LEMOD,
                     COQUE=(_F(GROUP_MA = 'MAI1',
                               EPAIS = .2,
                               ANGL_REP = (0.0, 0.0,),),),)

LACAR.debugPrint()

# add low level tests
vale = LACAR.sdj.CARCOQUE.VALE.get()
test.assertEqual(vale[0], 0.2)

test.printSummary()

FIN()
