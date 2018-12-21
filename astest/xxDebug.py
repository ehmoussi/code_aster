import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

DEBUG(SDVERI='OUI')

DEBUG(SDVERI='NON')

test.assertTrue( True )

FIN()
