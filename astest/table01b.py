# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

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
test.assertSequenceEqual(pytab.NOM_NUM.values(),
                         ['{0:<24}'.format(i) for i in table2])

tab2 = CALC_TABLE(TABLE=tab,
                  ACTION=_F(OPERATION='FILTRE',
                            NOM_PARA='NUMERO',
                            VALE_I=1),
                  INFO=2)

pytab2 = tab2.EXTR_TABLE()
test.assertSequenceEqual(pytab2.NUMERO.values(), [1])

test.printSummary()

FIN()
