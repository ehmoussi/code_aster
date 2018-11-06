#!/usr/bin/python
# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()



mesh = code_aster.Mesh()
mesh.readMedFile("test001f.mmed")


model = code_aster.Model()
model.setSupportMesh(mesh)
model.addModelingOnAllMesh(code_aster.Physics.Mechanics, code_aster.Modelings.Tridimensional)
model.build()


young = 200000.0
poisson = 0.3

acier = DEFI_MATERIAU(ELAS = _F(E = young,
                                NU = poisson,),)

affe_mat = code_aster.MaterialOnMesh(mesh)
affe_mat.addMaterialOnAllMesh(acier)
affe_mat.buildWithoutInputVariables()

imposed_dof_1 = code_aster.DisplacementDouble()
imposed_dof_1.setValue(code_aster.PhysicalQuantityComponent.Dx, 0.0)
imposed_dof_1.setValue(code_aster.PhysicalQuantityComponent.Dy, 0.0)
imposed_dof_1.setValue(code_aster.PhysicalQuantityComponent.Dz, 0.0)

char_meca_1 = code_aster.ImposedDisplacementDouble(model)
char_meca_1.setValue(imposed_dof_1, "Bas")
char_meca_1.build()

imposed_pres_1 = code_aster.PressureDouble()
imposed_pres_1.setValue(code_aster.PhysicalQuantityComponent.Pres, 1000.)

char_meca_2 = code_aster.DistributedPressureDouble(model)
char_meca_2.setValue(imposed_pres_1, "Haut")
char_meca_2.build()

study = code_aster.StudyDescription(model, affe_mat)
study.addMechanicalLoad(char_meca_1)
study.addMechanicalLoad(char_meca_2)
problem = code_aster.DiscreteProblem(study)

matr_elem_k = problem.computeMechanicalStiffnessMatrix()


solver = code_aster.MumpsSolver( code_aster.Renumbering.Metis )


nume_ddl_k = code_aster.DOFNumbering()
nume_ddl_k.setElementaryMatrix(matr_elem_k)
nume_ddl_k.computeNumbering()


matr_asse_k = code_aster.AssemblyMatrixDisplacementDouble()
matr_asse_k.appendElementaryMatrix(matr_elem_k)
matr_asse_k.setDOFNumbering(nume_ddl_k)
matr_asse_k.build()

comb_matrix = COMB_MATR_ASSE(COMB_R=_F(MATR_ASSE=matr_asse_k, COEF_R=1.0))

test.assertEqual(comb_matrix.getType(), "MATR_ASSE_DEPL_R")

test.printSummary()
