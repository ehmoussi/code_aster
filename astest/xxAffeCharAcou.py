import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("ahlv100a.mmed")

GUIDE=AFFE_MODELE(  MAILLAGE=MA,
                 AFFE=_F( TOUT = 'OUI', MODELISATION = '3D', PHENOMENE = 'ACOUSTIQUE') )

CHARACOU=AFFE_CHAR_ACOU(MODELE=GUIDE, VITE_FACE=_F( GROUP_MA = 'ENTREE', VNOR = 0.014+2.j))

test.assertTrue( True )

FIN()
