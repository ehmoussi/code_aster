import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("zzzz121a.mmed")

MACR_INFO_MAIL(
              MAILLAGE=MA,
              QUALITE='OUI',
              INTERPENETRATION='OUI',
              CONNEXITE='OUI',
              TAILLE='OUI',
              PROP_CALCUL='OUI',
              DIAMETRE='OUI'
               )

test.assertTrue( True )

FIN()
