import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("zzzz111a.mmed")

MODELE=AFFE_MODELE(
                 MAILLAGE=MA,AFFE=(
                     _F(  GROUP_MA = 'VOILE',
                            PHENOMENE = 'MECANIQUE',
                            MODELISATION = 'DKT'),))

CARAELEM=AFFE_CARA_ELEM(
                      MODELE=MODELE,
                       COQUE=_F(  GROUP_MA = 'VOILE',
                               EPAIS = 6.0E-1),)

test.assertTrue( True )

FIN()
