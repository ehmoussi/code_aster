#!/usr/bin/python

import code_aster
from code_aster.Commands import *

mail1 = LIRE_MAILLAGE( FORMAT = "MED" )

mail2 = LIRE_MAILLAGE( FORMAT = "GIBI", UNITE = 21 )
