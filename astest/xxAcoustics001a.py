
import code_aster
from code_aster.Commands import *

test = code_aster.TestCase()

MA = code_aster.Mesh.create()
MA.readMedFile("xxContact001a.mmed")

MO2 = code_aster.Model.create()
MO2.setSupportMesh(MA)
MO2.addModelingOnAllMesh(code_aster.Physics.Acoustics, code_aster.Modelings.Tridimensional)
MO2.build()

load = code_aster.AcousticsLoad.create(MO2)
load.addImposedPressureOnGroupsOfElements( ["FONDATION"], 1.+2.j )
load.addImposedNormalSpeedOnGroupsOfElements( ["FONDATION"], 3.+4.j )
load.addImpedanceOnAllMesh( 5.+6.j )
load.build()
load.debugPrint(8)

# Test trivial
test.assertTrue( True )