# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
# This file is part of code_aster.
#
# code_aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# code_aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------

import code_aster
from code_aster.Commands import *

code_aster.init("--test")

test = code_aster.TestCase()

MAT=DEFI_MATERIAU(ELAS = _F(RHO = 7.8E03,
                            NU = 0.3,
                            E = 2.1E11,
                            AMOR_ALPHA = 1.6E-5,
                            AMOR_BETA = 16.,),)

MAYA=code_aster.Mesh()
MAYA.readMedFile('xxModalMechanics001a.med')
test.assertEqual(MAYA.getType(), "MAILLAGE_SDASTER")

CHMAT=AFFE_MATERIAU(MAILLAGE = MAYA,
                    AFFE = _F(TOUT = 'OUI',
                              MATER = MAT,),)

POVOL=AFFE_MODELE(MAILLAGE = MAYA,
                  AFFE=_F(TOUT = 'OUI',
                          MODELISATION = '3D',
                          PHENOMENE = 'MECANIQUE',),)

imposedPres1 = code_aster.PressureReal()
imposedPres1.setValue( code_aster.PhysicalQuantityComponent.Pres, 500000. )
PRESSION = code_aster.DistributedPressureReal(POVOL)
PRESSION.setValue( imposedPres1, "PRESSION" )
PRESSION.build()
test.assertEqual(PRESSION.getType(), "CHAR_MECA")

imposedDof1 = code_aster.DisplacementReal()
imposedDof1.setValue( code_aster.PhysicalQuantityComponent.Dy, 0.0 )
CharMeca1 = code_aster.ImposedDisplacementReal(POVOL)
CharMeca1.setValue( imposedDof1, "COND1" )
CharMeca1.build()
test.assertEqual(CharMeca1.getType(), "CHAR_MECA")

imposedDof2 = code_aster.DisplacementReal()
imposedDof2.setValue( code_aster.PhysicalQuantityComponent.Dz, 0.0 )
CharMeca2 = code_aster.ImposedDisplacementReal(POVOL)
CharMeca2.setValue( imposedDof1, "CONDZG" )
CharMeca2.build()
test.assertEqual(CharMeca2.getType(), "CHAR_MECA")

imposedDof3 = code_aster.DisplacementReal()
imposedDof3.setValue( code_aster.PhysicalQuantityComponent.Dx, 0.0 )
CharMeca3 = code_aster.ImposedDisplacementReal(POVOL)
CharMeca3.setValue( imposedDof1, "CENTRE" )
CharMeca3.build()
test.assertEqual(CharMeca2.getType(), "CHAR_MECA")

imposedDof4 = code_aster.DisplacementReal()
imposedDof4.setValue( code_aster.PhysicalQuantityComponent.Dx, 0.0 )
CharMeca4 = code_aster.ImposedDisplacementReal(POVOL)
CharMeca4.setValue( imposedDof1, "DROITE" )
CharMeca4.build()
test.assertEqual(CharMeca4.getType(), "CHAR_MECA")

study = code_aster.StudyDescription(POVOL, CHMAT)
study.addMechanicalLoad(PRESSION)
study.addMechanicalLoad(CharMeca1)
study.addMechanicalLoad(CharMeca2)
study.addMechanicalLoad(CharMeca3)
study.addMechanicalLoad(CharMeca4)

dProblem = code_aster.DiscreteProblem(study)
K_ELEM1 = dProblem.computeMechanicalStiffnessMatrix()
M_ELEM1 = dProblem.computeMechanicalMassMatrix()
A_ELEM1 = dProblem.computeMechanicalDampingMatrix(K_ELEM1, M_ELEM1)


# at least it pass here!
test.printSummary()

FIN()
