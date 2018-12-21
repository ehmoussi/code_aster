import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("zzzz164b.mmed")

CH_POS=CREA_CHAMP(TITRE = 'POSITION DES NOEUDS MILIEU',
                  INFO = 2 ,
                  TYPE_CHAM = 'NOEU_GEOM_R',
                  OPERATION = 'EXTR',
                  MAILLAGE = MA,
                  NOM_CHAM ='GEOMETRIE',)

POS_N17 = POST_RELEVE_T(ACTION=_F(INTITULE = 'POSITION',
                                 OPERATION = 'EXTRACTION',
                                 NOEUD = 'N17',
                                 CHAM_GD = CH_POS,
                                 TOUT_CMP ='OUI'))

test.assertTrue( True )

FIN()
