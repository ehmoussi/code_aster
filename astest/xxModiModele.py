import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("mumps02a.mmed")


MO=AFFE_MODELE(MAILLAGE=MA, 
               AFFE=_F(TOUT='OUI', PHENOMENE='MECANIQUE', MODELISATION='D_PLAN_INCO_UPG'),
               DISTRIBUTION=_F(METHODE='SOUS_DOMAINE',NB_SOUS_DOMAINE=4),
)

MODI_MODELE(reuse=MO, MODELE=MO, DISTRIBUTION=_F(METHODE='CENTRALISE'))

test.assertTrue( True )

FIN()
