#!/usr/bin/python
# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

mail1 = LIRE_MAILLAGE( FORMAT = "MED" )

with test.assertRaisesRegex(ValueError, "must be in"):
    LIRE_MAILLAGE( FORMAT = "xxx", UNITE = 21 )

MA0=LIRE_MAILLAGE(FORMAT='MED',UNITE=22)

# Groupes de mailles
MA1=CREA_MAILLAGE(MAILLAGE=MA0, RESTREINT=_F(GROUP_MA='V001'), )

test.printSummary()

FIN()
