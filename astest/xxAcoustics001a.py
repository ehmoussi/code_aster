
import code_aster
from code_aster.Commands import *

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("xxContact001a.mmed")

MO2 = code_aster.Modeling.Model()
MO2.setSupportMesh(MA)
MO2.addModelingOnAllMesh(code_aster.Acoustics, code_aster.Tridimensional)
MO2.build()

load = code_aster.Loads.AcousticsLoad()
load.setSupportModel( MO2 )
load.addImposedPressureOnGroupsOfElements( ["FONDATION"], 1.+2.j )
load.addImposedNormalSpeedOnGroupsOfElements( ["FONDATION"], 3.+4.j )
load.addImpedanceOnAllMesh( 5.+6.j )
load.build()
load.debugPrint(8)

# Test trivial
test.assertTrue( True )
