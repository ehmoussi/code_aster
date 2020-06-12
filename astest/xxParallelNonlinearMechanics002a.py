# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

# test = xxParallelNonlinearMechanics001a mais Preconditioning.Gamg
# en ajoutant un Frampe pour le chargement
test = code_aster.TestCase()

#parallel=False
parallel=True

if (parallel):
    monMaillage = code_aster.ParallelMesh()
    monMaillage.readMedFile( "xxParallelNonlinearMechanics001a" )
else:
    monMaillage = code_aster.Mesh()
    monMaillage.readMedFile("xxParallelNonlinearMechanics001a.med")

monModel = code_aster.Model(monMaillage)
monModel.addModelingOnMesh( code_aster.Physics.Mechanics, code_aster.Modelings.Tridimensional )
monModel.build()

acier=DEFI_MATERIAU(ELAS=_F(E=200000.,
                            NU=0.3,),
                    ECRO_LINE=_F(D_SIGM_EPSI=2000.,
                                 SY=200.,),);

affectMat = code_aster.MaterialField(monMaillage)
affectMat.addMaterialsOnMesh( acier )
affectMat.buildWithoutExternalVariable()

charMeca1 = code_aster.KinematicsMechanicalLoad()
charMeca1.setModel(monModel)
charMeca1.addImposedMechanicalDOFOnCells(code_aster.PhysicalQuantityComponent.Dx, 0., "COTE_B")
charMeca1.addImposedMechanicalDOFOnCells(code_aster.PhysicalQuantityComponent.Dy, 0., "COTE_B")
charMeca1.addImposedMechanicalDOFOnCells(code_aster.PhysicalQuantityComponent.Dz, 0., "COTE_B")
charMeca1.build()

charMeca2 = code_aster.KinematicsMechanicalLoad()
charMeca2.setModel(monModel)
charMeca2.addImposedMechanicalDOFOnCells(code_aster.PhysicalQuantityComponent.Dy, 0.1, "COTE_H")
charMeca2.addImposedMechanicalDOFOnCells(code_aster.PhysicalQuantityComponent.Dz, 0.1, "COTE_H")
charMeca2.build()

# Define the nonlinear method that will be used
monSolver = code_aster.PetscSolver( code_aster.Renumbering.Sans )
monSolver.setPreconditioning(code_aster.Preconditioning.Gamg)

# Define a nonlinear Analysis
temps = [0., 0.5, 1.]
timeList = code_aster.TimeStepManager()
timeList.setTimeList( temps )

error1 = code_aster.EventError()
action1 = code_aster.SubstepingOnError()
action1.setAutomatic( False )
error1.setAction( action1 )
timeList.addErrorManager( error1 )
timeList.build()
#timeList.debugPrint( 6 )

fMult = code_aster.Function()
fMult.setParameterName("INST")
fMult.setValues([0.,1.], [0.,1.])
#fMult.debugPrint( 6 )

# set fMult dans STAT_NON_LINE en python ??
resu=STAT_NON_LINE( MODELE=monModel,
                    CHAM_MATER=affectMat,
                    EXCIT=( _F( CHARGE = charMeca1,),
                            _F( CHARGE = charMeca2,
                                FONC_MULT = fMult,),
                        ),
                   COMPORTEMENT=_F( RELATION = 'VMIS_ISOT_LINE',
                                    DEFORMATION = 'PETIT',
                                    ),
                    SOLVEUR=_F(METHODE='PETSC', PRE_COND='ML'),
                    INCREMENT=_F(   LIST_INST = timeList,),
                                    NEWTON=_F(  MATRICE = 'TANGENTE',
                                                REAC_INCR = 1,
                                                REAC_ITER = 1,),
                    #INFO=2,
                         )
#resu.debugPrint( 6 )

# at least it passes here!
test.assertEqual(resu.getType(), "EVOL_NOLI")
test.printSummary()

# if (parallel):
#     rank = code_aster.getMPIRank()
#     resu.printMedFile('/tmp/par_%d.resu.med'%rank)
# else:
#     resu.printMedFile('/tmp/seq.resu.med')

FIN()
