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

## This test has two independant domains. One on each cpu then there is no joint in the parallel mesh

monMaillage = code_aster.ParallelMesh()
monMaillage.readMedFile("xxParallelNonlinearMechanics004a")

monModel = AFFE_MODELE(MAILLAGE=monMaillage,
                        AFFE=_F(TOUT='OUI',
                         PHENOMENE='MECANIQUE',
                         MODELISATION='3D',),)

acier = DEFI_MATERIAU(ELAS=_F(E=200000.,
                              NU=0.3,),)

affectMat = AFFE_MATERIAU(MAILLAGE=monMaillage,
                                MODELE=monModel,
                                AFFE=_F(TOUT='OUI',
                                MATER=acier,),)

CHAR1=AFFE_CHAR_CINE(MODELE=monModel,
                     MECA_IMPO=(_F(GROUP_MA='Faces1',
                                   DZ=0.1,
                                       ),
                                _F(GROUP_MA='Faces2',
                                   DZ=0.1,),),)

CHAR2=AFFE_CHAR_CINE(MODELE=monModel,
                     MECA_IMPO=(_F(GROUP_MA='Faces_Haut',
                                   DX=0, DY=0., DZ=0.),),)



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

RAMPE=DEFI_FONCTION(NOM_PARA='INST',VALE=(0,0,1,1),)

resu = STAT_NON_LINE(MODELE=monModel,
                     CHAM_MATER=affectMat,
                     EXCIT=(_F(CHARGE=CHAR1,FONC_MULT=RAMPE),
                            _F(CHARGE=CHAR2,FONC_MULT=RAMPE,),
                            ),
                     COMPORTEMENT=_F(RELATION='ELAS',
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

rank = code_aster.getMPIRank()
resu.printMedFile('par_%d.resu.med'%rank)

FIN()
