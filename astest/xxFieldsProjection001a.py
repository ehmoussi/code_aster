
import code_aster
from code_aster.Commands import *

test = code_aster.TestCase()

MA1 = code_aster.Mesh.create()
MA1.readMedFile("zzzz261a.18")
MA2 = code_aster.Mesh.create()
MA2.readMedFile("zzzz261a.19")

MATPROJ=PROJ_CHAMP(METHODE='COLLOCATION',  MAILLAGE_1=MA1, MAILLAGE_2=MA2, PROJECTION='NON')

# Test trivial
test.assertTrue( True )
