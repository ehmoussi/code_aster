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

DEBUT(CODE=_F(NIV_PUB_WEB='INTERNET',),DEBUG=_F(SDVERI='OUI',),INFO=1,)

nProc = code_aster.getMPINumberOfProcs()
parallel= (nProc>1)
rank = code_aster.getMPIRank()

if (parallel):
    MAIL = code_aster.ParallelMesh()
    MAIL.readMedFile("xxParallelMechanicalLoad007a")

model = AFFE_MODELE( MAILLAGE = MAIL,
                        AFFE = (_F( MODELISATION = "3D",
                                   PHENOMENE = "MECANIQUE",
                                   TOUT = "OUI", ),
                                _F( MODELISATION = "DKT",
                                   PHENOMENE = "MECANIQUE",
                                   GROUP_MA = "Surf", ),
                                   ),)

CARAMECA=AFFE_CARA_ELEM(MODELE=model,
                        COQUE=_F(GROUP_MA='Surf',
                                 EPAIS=0.1,),)

MATER1 = DEFI_MATERIAU( ELAS = _F( E = 200000.0,
                                   NU = 0.3,
                                   RHO = 1000.), )

AFFMAT = AFFE_MATERIAU( MAILLAGE = MAIL,
                        AFFE = _F( TOUT = 'OUI',
                                   MATER = MATER1, ), )

load = AFFE_CHAR_CINE( MODELE = model,
                       MECA_IMPO = ( _F( GROUP_MA = "Encast", DX = 0. ),
                                     _F( GROUP_MA = "Encast", DY = 0. ),
                                     _F( GROUP_MA = "Encast", DZ = 0. ), ), )

load2 = AFFE_CHAR_MECA(MODELE=model,
                      PESANTEUR=_F(GRAVITE=1.0,
                                   DIRECTION=(0.0, -1.0, 0.0),),
                      INFO=1,
                      VERI_NORM='NON',)

resu = MECA_STATIQUE( MODELE = model,
                      CHAM_MATER = AFFMAT,
                      CARA_ELEM = CARAMECA,
                      EXCIT = ( _F( CHARGE = load, ),
                                _F( CHARGE = load2, ), ),
                      SOLVEUR = _F( METHODE = "MUMPS",),
                      INFO=2,)


POST=POST_ELEM( MINMAX=_F(NOM_CHAM='DEPL',
                            NOM_CMP=('DX',),
                            TOUT='OUI',
                            RESULTAT=resu,
                            MODELE=model))

value_test = [0.00023576994388906295, 0.0002350130298428169]

TEST_TABLE(
           VALE_CALC=value_test[rank],
           NOM_PARA='MAX_DX',
           TABLE=POST,
           )



FIN()
