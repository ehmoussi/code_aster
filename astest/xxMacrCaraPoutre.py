import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

TCARS=MACR_CARA_POUTRE(    SYME_Z='OUI',FORMAT='MED',
                              ORIG_INER=(0., -0.025,) )

test.assertTrue( True )

FIN()
