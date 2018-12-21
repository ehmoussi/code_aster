import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("hsnv132b.mmed")

MACR_ADAP_MAIL(ADAPTATION='RAFF_DERA_ZONE',
                  ZONE=_F(TYPE='DISQUE',
                        X_CENTRE = 0.5,
                        Y_CENTRE = 0.5,
                        RAYON = 0.1, ),
                  MAILLAGE_N = MA,
                  MAILLAGE_NP1 = CO('MAILLAG1'),
                  QUALITE='OUI',
                  TAILLE='OUI',
                  )

test.assertTrue( True )

FIN()
