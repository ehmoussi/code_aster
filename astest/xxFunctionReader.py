# coding: utf-8

import code_aster
from math import pi

from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

CTRAC = LIRE_FONCTION(UNITE=21,
                      NOM_PARA='EPSI',
                      PROL_DROITE='CONSTANT',)

test.assertEqual(CTRAC.getType(), "FONCTION_SDASTER")

test.printSummary()

FIN()
