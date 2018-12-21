import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()
MA = code_aster.Mesh()
MA.readMedFile("sslv200a.mmed")

MO=AFFE_MODELE(    MAILLAGE=MA,  VERI_JACOBIEN='OUI',
                         AFFE=_F(  TOUT = 'OUI',
                                PHENOMENE = 'MECANIQUE',
                                MODELISATION = '3D') )

CHAMEL7=CALC_CHAM_ELEM(    MODELE=MO,
                             GROUP_MA='GMA20',
                             OPTION='COOR_ELGA' )

test.assertTrue( True )

FIN()
