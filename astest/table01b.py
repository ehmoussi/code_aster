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

table1 = [0, 1, 2, ]
table2 = ["00", "01", "02", ]

tab = CREA_TABLE(LISTE=(_F(PARA='NUMERO',
                           LISTE_I=table1,),
                        _F(PARA='NOM_NUM',
                           LISTE_K=table2,
                           TYPE_K='K24',),),
                 TITRE='Table title')

tab.debugPrint()

test.assertEqual(tab.getType(), 'TABLE_SDASTER')
test.assertEqual(tab['NUMERO', 1], 0)
test.assertEqual(tab.TITRE().strip(), 'Table title')

pytab = tab.EXTR_TABLE()
test.assertSequenceEqual(list(pytab.NOM_NUM.values()), table2)

tab2 = CALC_TABLE(TABLE=tab,
                  ACTION=_F(OPERATION='FILTRE',
                            NOM_PARA='NUMERO',
                            VALE_I=1),
                  INFO=2)

pytab2 = tab2.EXTR_TABLE()
test.assertSequenceEqual(list(pytab2.NUMERO.values()), [1])

test.printSummary()

FIN()
