# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

table1 = [0, 1, 2,]
table2 = ["00", "01", "02",]

TAB=CREA_TABLE(LISTE=(_F(PARA='NUMERO',
                         LISTE_I=table1,),
                      _F(PARA='NOM_NUM',
                         LISTE_K=table2,
                         TYPE_K='K24',),),)

TAB.debugPrint()
