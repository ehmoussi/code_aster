import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

TAUN1=DEFI_FONCTION(    NOM_PARA='INST',
                           VALE=(  0.,           0.,
                                   1.,         500.,
                                   2.,         200.,
                                   3.,         400.,
                                   4.,         300.,
                                   5.,         500.,
                                   6.,        -300.,
                                   7.,         200.,
                                   8.,        -500.,  )  )

TAUN2=DEFI_FONCTION(  NOM_PARA='INST',
                           VALE=(  0.,           0.,
                                   1.,         250.,
                                   2.,         100.,
                                   3.,         200.,
                                   4.,         150.,
                                   5.,         250.,
                                   6.,        -150.,
                                   7.,         100.,
                                   8.,        -250.,  )  )

#
#-----------------------------------------------------------------------

TAB_1=POST_FATIGUE(    CHARGEMENT='UNIAXIAL',
                         HISTOIRE=_F(  SIGM = TAUN1),
                         COMPTAGE='RAINFLOW',
                             INFO=2                 )
                             
test.assertTrue( True )

FIN()
