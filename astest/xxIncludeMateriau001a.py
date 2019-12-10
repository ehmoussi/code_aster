# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()


# DEFINITION DU MATERIAU PAR INCLUDE_MATERIAU
MAT=INCLUDE_MATERIAU(NOM_AFNOR='A42',
                     TYPE_MODELE='REF',
                     VARIANTE='A',
                     TYPE_VALE='NOMI',
                     EXTRACTION=_F(COMPOR='ELAS',
                                   TEMP_EVAL=100.0,),
                     INFO=2,)

test.assertEqual(MAT.getType(), "MATER_SDASTER")


test.printSummary()

FIN()
