# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("xxContact001a.mmed")

MO = code_aster.Model(MA)
MO.addModelingOnAllMesh(code_aster.Physics.Mechanics, code_aster.Modelings.Tridimensional)
MO.build()

z1 = code_aster.Contact()
test.assertEqual(z1.getType(), "CHAR_CONTACT")
#cDef.setModel( MO )
#cDef.build()
#cDef.debugPrint(8)

# just check it pass here!
test.printSummary()

FIN()
