#!/usr/bin/python
# coding: utf-8

import code_aster
from code_aster.Commands import *


test = code_aster.TestCase()

mail1 = LIRE_MAILLAGE( FORMAT = "MED" )

with test.assertRaisesRegexp(ValueError, "must be in"):
    LIRE_MAILLAGE( FORMAT = "GIBI", UNITE = 21 )

test.printSummary()
