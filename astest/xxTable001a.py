# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

table1 = [0, 1, 2,]
table2 = ["00", "01", "02",]

TAB=CREA_TABLE(LISTE=(_F(PARA='NUMERO',
                         LISTE_I=table1,),
                      _F(PARA='NOM_NUM',
                         LISTE_K=table2,
                         TYPE_K='K24',),),
               TITRE='Table title')

TAB.debugPrint()

test.assertEqual(TAB.getType(), 'TABLE')
test.assertEqual(TAB['NUMERO', 1], 0)
test.assertEqual(TAB.TITRE().strip(), 'Table title')

tab = TAB.EXTR_TABLE()
test.assertSequenceEqual(tab.NOM_NUM.values(),
                         ['{0:<24}'.format(i) for i in table2])

TAB2 = CALC_TABLE(TABLE=TAB,
                  ACTION=_F(OPERATION='FILTRE',
                            NOM_PARA='NUMERO',
                            VALE_I=1),
                  INFO=2)

test.printSummary()
