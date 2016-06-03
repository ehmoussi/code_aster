#!/usr/bin/python
# coding: utf-8

import code_aster

monMaillage = code_aster.Mesh()
monMaillage.readMedFile( "test001f.mmed" )

monModel = code_aster.Model()
monModel.setSupportMesh( monMaillage )
monModel.addModelingOnAllMesh( code_aster.Mechanics, code_aster.Tridimensional )
monModel.build()

YOUNG = 200000.0;
POISSON = 0.3;

materElas = code_aster.MaterialBehaviour.ElasMaterialBehaviour()
materElas.setDoubleValue( "E", YOUNG )
materElas.setDoubleValue( "Nu", POISSON )

acier = code_aster.Material()
acier.addMaterialBehaviour( materElas )

Kinv= 3.2841e-4
Kv=1./Kinv
SY = 437.0;
Rinf = 758.0;
Qzer   = 758.0-437.;
Qinf   = Qzer + 100.;
b = 2.3;
C1inf = 63767.0/2.0
C2inf = 63767.0/2.0
Gam1 = 341.0
Gam2 = 341.0
C_Pa = 1.e+6

materViscochab = code_aster.MaterialBehaviour.ViscochabMaterialBehaviour()
materViscochab.setDoubleValue( "K",  SY*C_Pa )
materViscochab.setDoubleValue( "B",  b )
materViscochab.setDoubleValue( "Mu", 10 )
materViscochab.setDoubleValue( "Q_m", Qinf * C_Pa )
materViscochab.setDoubleValue( "Q_0", Qzer * C_Pa )
materViscochab.setDoubleValue( "C1", C1inf * C_Pa )
materViscochab.setDoubleValue( "C2", C2inf * C_Pa )
materViscochab.setDoubleValue( "G1_0", Gam1 )
materViscochab.setDoubleValue( "G2_0", Gam2 )
materViscochab.setDoubleValue( "K_0", Kv * C_Pa)
materViscochab.setDoubleValue( "N", 11)
materViscochab.setDoubleValue( "A_k", 1.)

acier.addMaterialBehaviour( materViscochab )
acier.build()
acier.debugPrint(6)

affectMat = code_aster.MaterialOnMesh()
affectMat.setSupportMesh( monMaillage )
affectMat.addMaterialOnAllMesh( acier )
affectMat.build()

imposedDof1 = code_aster.DisplacementDouble()
imposedDof1.setValue( code_aster.Loads.Dx, 0.0 )
imposedDof1.setValue( code_aster.Loads.Dy, 0.0 )
imposedDof1.setValue( code_aster.Loads.Dz, 0.0 )
CharMeca1 = code_aster.ImposedDisplacementDouble()
CharMeca1.setSupportModel( monModel )
CharMeca1.setValue( imposedDof1, "Bas" )
CharMeca1.build()

imposedPres1 = code_aster.PressureDouble()
imposedPres1.setValue( code_aster.Loads.Pres, 1000. )
CharMeca2 = code_aster.DistributedPressureDouble()
CharMeca2.setSupportModel( monModel )
CharMeca2.setValue( imposedPres1, "Haut" )
CharMeca2.build()

matr_elem = code_aster.ElementaryMatrix()
matr_elem.setSupportModel( monModel )
matr_elem.setMaterialOnMesh( affectMat )
matr_elem.addMechanicalLoad( CharMeca1 )
matr_elem.addMechanicalLoad( CharMeca2 )
matr_elem.computeMechanicalRigidity()

monSolver = code_aster.LinearSolver( code_aster.LinearAlgebra.Mumps, code_aster.LinearAlgebra.Metis )

numeDDL = code_aster.DOFNumbering()
numeDDL.setElementaryMatrix( matr_elem )
numeDDL.setLinearSolver( monSolver )
numeDDL.computeNumerotation()
numeDDL.debugPrint(6)

vectElem = code_aster.ElementaryVector()
vectElem.addMechanicalLoad( CharMeca1 )
vectElem.addMechanicalLoad( CharMeca2 )
vectElem.computeMechanicalLoads()
vectElem.debugPrint(6)

retour = vectElem.assembleVector( numeDDL )

matrAsse = code_aster.AssemblyMatrixDouble()
matrAsse.setElementaryMatrix( matr_elem )
matrAsse.setDOFNumbering( numeDDL )
matrAsse.build()
matrAsse.factorization()

resu = monSolver.solveDoubleLinearSystem( matrAsse, retour )

resu.printMEDFile( "test.med" )
