#!/usr/bin/python

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
materViscochab.setDoubleValue( "Q_M", Qinf * C_Pa )
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

monCharMeca1 = code_aster.MechanicalLoad()
monCharMeca1.setSupportModel( monModel )
monCharMeca1.setDisplacementOnNodes( "DX", 0.0, "Bas" )
monCharMeca1.setDisplacementOnNodes( "DY", 0.0, "Bas" )
monCharMeca1.setDisplacementOnNodes( "DZ", 0.0, "Bas" )
monCharMeca1.build()

monCharMeca2 = code_aster.MechanicalLoad()
monCharMeca2.setSupportModel( monModel )
monCharMeca2.setPressureOnElements( 1000., "Haut" )
monCharMeca2.build()

matr_elem = code_aster.ElementaryMatrix()
matr_elem.setSupportModel( monModel )
matr_elem.setMaterialOnMesh( affectMat )
matr_elem.addMechanicalLoad( monCharMeca1 )
matr_elem.addMechanicalLoad( monCharMeca2 )
matr_elem.computeMechanicalRigidity()

monSolver = code_aster.LinearSolver( code_aster.Mumps, code_aster.Metis )

numeDDL = code_aster.DOFNumerotation()
numeDDL.setElementaryMatrix( matr_elem )
numeDDL.setLinearSolver( monSolver )
numeDDL.computeNumerotation()

vectElem = code_aster.ElementaryVector()
vectElem.addMechanicalLoad( monCharMeca1 )
vectElem.addMechanicalLoad( monCharMeca2 )
vectElem.computeMechanicalLoads()

retour = vectElem.assembleVector( numeDDL )

matrAsse = code_aster.AssemblyMatrixDouble()
matrAsse.setElementaryMatrix( matr_elem )
matrAsse.setDOFNumerotation( numeDDL )
matrAsse.build()
matrAsse.factorization()

resu = monSolver.solveDoubleLinearSystem( matrAsse, retour )

resu.printMEDFormat( "test.med" )
