import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

T1=POST_USURE(  PUIS_USURE=0.5,
                LOI_USURE='EDF_MZ',
                MOBILE=_F(),
                CONTACT='TUBE_BAV',
                RAYON_MOBILE=1.,
                LARGEUR_OBST=10.,
                INST=( 1., 2., 3., 4., 5., 6., 7., ),
                COEF_INST=31536000.)

test.assertTrue( True )

FIN()
