# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()


# Mesh
mesh = code_aster.Mesh()
mesh.readMedFile("xxMechanicalLoad001a.mmed")

mesh2 = code_aster.Mesh()
mesh2.readMedFile("xxModalMechanics001a.med")

mesh_assembler = ASSE_MAILLAGE(MAILLAGE_1=mesh,
                               MAILLAGE_2=mesh2,
                               OPERATION="SOUS_STR")

test.assertEqual(mesh_assembler.getType(), "MAILLAGE_SDASTER")


test.printSummary()

FIN()
