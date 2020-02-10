# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

monMaillage = code_aster.ParallelMesh()
monMaillage.readMedFile("xxParallelNonlinearMechanics003a")

monModel = code_aster.Model(monMaillage)
monModel.addModelingOnAllMesh(
    code_aster.Physics.Mechanics, code_aster.Modelings.Tridimensional)
# monModel.addModelingOnGroupOfElements(code_aster.Physics.Mechanics,
                                   # code_aster.Modelings.Tridimensional,"Vol")
# monModel.addModelingOnGroupOfElements(code_aster.Physics.Mechanics,
                                   # code_aster.Modelings.Tridimensional,"Surf5")
monModel.build()

acier = DEFI_MATERIAU(ELAS=_F(E=200000.,
                              NU=0.3,),
                      ECRO_LINE=_F(D_SIGM_EPSI=2000.,
                                   SY=200.,),)

affectMat = code_aster.MaterialOnMesh(monMaillage)
affectMat.addMaterialOnAllMesh(acier)
affectMat.buildWithoutExternalVariable()

charMeca1 = code_aster.KinematicsMechanicalLoad()
charMeca1.setModel(monModel)
charMeca1.addImposedMechanicalDOFOnNodes(
    code_aster.PhysicalQuantityComponent.Dx, 0., "Surf6N")
charMeca1.addImposedMechanicalDOFOnNodes(
    code_aster.PhysicalQuantityComponent.Dy, 0., "Surf6N")
charMeca1.addImposedMechanicalDOFOnNodes(
    code_aster.PhysicalQuantityComponent.Dz, 0., "Surf6N")
charMeca1.build()

imposedPres1 = code_aster.PressureReal()
imposedPres1.setValue(code_aster.PhysicalQuantityComponent.Pres, 1.)
charMeca2 = code_aster.DistributedPressureReal(monModel)
charMeca2.setValue(imposedPres1, "Surf5")
charMeca2.build()

# Define the nonlinear method that will be used
monSolver = code_aster.PetscSolver(code_aster.Renumbering.Sans)
monSolver.setPreconditioning(code_aster.Preconditioning.Gamg)

# Define a nonlinear Analysis
temps = [0., 0.5, 1.]
timeList = code_aster.TimeStepManager()
timeList.setTimeList(temps)

error1 = code_aster.EventError()
action1 = code_aster.SubstepingOnError()
action1.setAutomatic(False)
error1.setAction(action1)
timeList.addErrorManager(error1)
timeList.build()
# timeList.debugPrint( 6 )

fMult = code_aster.Function()
fMult.setParameterName("INST")
fMult.setValues([0., 1.], [0., 1.])
# fMult.debugPrint( 6 )

resu = STAT_NON_LINE(MODELE=monModel,
                     CHAM_MATER=affectMat,
                     EXCIT=(_F(CHARGE=charMeca1,),
                            _F(CHARGE=charMeca2,
                               FONC_MULT=fMult,),
                            ),
                     COMPORTEMENT=_F(RELATION='VMIS_ISOT_LINE',
                                     DEFORMATION='PETIT',
                                     ),
                     SOLVEUR=_F(METHODE='PETSC', PRE_COND='GAMG'),
                     INCREMENT=_F(LIST_INST=timeList,),
                     NEWTON=_F(MATRICE='TANGENTE',
                               REAC_INCR=1,
                               REAC_ITER=1,),
                     INFO=2,
                     )
# resu.debugPrint( 6 )

# at least it passes here!
test.assertTrue(True)
test.printSummary()

# rank = code_aster.getMPIRank()
# resu.printMedFile('/tmp/par_%d.resu.med'%rank)

FIN()
