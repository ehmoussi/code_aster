
import code_aster
from code_aster.Commands import *

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("xxContact001a.mmed")

MO = code_aster.Modeling.Model()
MO.setSupportMesh(MA)
MO.addModelingOnAllMesh(code_aster.Mechanics, code_aster.Tridimensional)
MO.build()

z1 = code_aster.Interactions.ContactZone.DiscretizedContactZone()
z1.addMasterGroupOfElements("FONDATION")
z1.addSlaveGroupOfElements("ESCLAVE1")

cDef = code_aster.Interactions.ContactDefinition.DiscretizedContact()
cDef.setModel( MO )
cDef.addContactZone( z1 )
cDef.build()
cDef.debugPrint(8)

# just check it pass here!
test.assertTrue( True )
test.printSummary()
