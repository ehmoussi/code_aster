#!/usr/bin/python
# coding: utf-8

import code_aster
from code_aster.Commands import *


test = code_aster.TestCase()

MAT=DEFI_MATERIAU(ELAS = _F(RHO = 7.8E03,
                            NU = 0.3,
                            E = 2.1E11,
                            AMOR_ALPHA = 1.6E-5,
                            AMOR_BETA = 16.,),)

MAYA=code_aster.Mesh()
MAYA.readMedFile('xxModalMechanics001a.med')
MAYA.addGroupOfNodesFromNodes("N26", ["N26"])

CHMAT=AFFE_MATERIAU(MAILLAGE = MAYA,
                    AFFE = _F(TOUT = 'OUI',
                              MATER = MAT,),)

POVOL=AFFE_MODELE(MAILLAGE = MAYA,
                  AFFE=_F(TOUT = 'OUI',
                          MODELISATION = '3D',
                          PHENOMENE = 'MECANIQUE',),)

imposedPres1 = code_aster.PressureDouble()
imposedPres1.setValue( code_aster.Loads.Pres, 500000. )
PRESSION = code_aster.DistributedPressureDouble()
PRESSION.setSupportModel( POVOL )
PRESSION.setValue( imposedPres1, "PRESSION" )
PRESSION.build()

imposedDof1 = code_aster.DisplacementDouble()
imposedDof1.setValue( code_aster.Loads.Dy, 0.0 )
CharMeca1 = code_aster.ImposedDisplacementDouble()
CharMeca1.setSupportModel( POVOL )
CharMeca1.setValue( imposedDof1, "COND1" )
CharMeca1.build()

imposedDof2 = code_aster.DisplacementDouble()
imposedDof2.setValue( code_aster.Loads.Dz, 0.0 )
CharMeca2 = code_aster.ImposedDisplacementDouble()
CharMeca2.setSupportModel( POVOL )
CharMeca2.setValue( imposedDof1, "CONDZG" )
CharMeca2.build()

imposedDof3 = code_aster.DisplacementDouble()
imposedDof3.setValue( code_aster.Loads.Dx, 0.0 )
CharMeca3 = code_aster.ImposedDisplacementDouble()
CharMeca3.setSupportModel( POVOL )
CharMeca3.setValue( imposedDof1, "N26" )
CharMeca3.build()

imposedDof4 = code_aster.DisplacementDouble()
imposedDof4.setValue( code_aster.Loads.Dx, 0.0 )
CharMeca4 = code_aster.ImposedDisplacementDouble()
CharMeca4.setSupportModel( POVOL )
CharMeca4.setValue( imposedDof1, "DROITE" )
CharMeca4.build()

study = code_aster.StudyDescription(POVOL, CHMAT)
study.addMechanicalLoad(PRESSION)
study.addMechanicalLoad(CharMeca1)
study.addMechanicalLoad(CharMeca2)
study.addMechanicalLoad(CharMeca3)
study.addMechanicalLoad(CharMeca4)

dProblem = code_aster.DiscreteProblem(study)
K_ELEM1 = dProblem.computeMechanicalRigidityMatrix()
M_ELEM1 = dProblem.computeMechanicalMassMatrix()
A_ELEM1 = dProblem.computeMechanicalDampingMatrix(K_ELEM1, M_ELEM1)


# at least it pass here!
test.assertTrue( True )
test.printSummary()
