# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
import math
from code_aster.Cata.Syntax import _F, MACRO, SIMP
from code_aster.Cata.DataStructure import CO as typCO
from code_aster.Cata.DataStructure import (maillage_sdaster, modele_sdaster, mater_sdaster,
    cham_no_sdaster, listr8_sdaster, cham_mater, char_meca,resultat_sdaster, table_sdaster)
from code_aster.Commands.ExecuteCommand import UserMacro
from code_aster.Commands import DEFI_FONCTION 
from code_aster.Commands import SIMU_POINT_MAT

def test_init_ops(self,TINI,TFIN,TMIL,MATER,LIST_INST,**args):
    import numpy as NP

    ier=0
  # La macro compte pour 1 dans la numerotation des commandes
    self.set_icmd(1)
  # On importe les definitions des commandes a utiliser dans la macro
    SIMU_POINT_MAT = self.get_cmd('SIMU_POINT_MAT')
    DEFI_FONCTION  = self.get_cmd('DEFI_FONCTION')
  # Le concept sortant dans le contexte de la macro
    self.DeclareOut('SPM',self.sd)

    __coef1b=DEFI_FONCTION(NOM_PARA='INST',
                     VALE=(0 ,0,
                           10,-1.E4,
                           25,1.E4,
                           40,-1.E4,),
                     PROL_DROITE='CONSTANT',);

    __coef2b=DEFI_FONCTION(NOM_PARA='INST',
                     VALE=(0 ,- 5.E4,
                           50,- 5.E4,),
                     PROL_DROITE='CONSTANT',);

    __u2=SIMU_POINT_MAT(COMPORTEMENT=_F(RELATION='HUJEUX',
                               ITER_INTE_MAXI=20,
                               RESI_INTE_RELA=1E-8,
                               ITER_INTE_PAS =-5,
                               ALGO_INTE='SPECIFIQUE'),
                  MATER=MATER,
                  INCREMENT=_F(LIST_INST=LIST_INST,
                               INST_INIT=TINI,
                               INST_FIN=TMIL,),
                  NEWTON=_F(MATRICE='TANGENTE',
                            REAC_ITER=1,),
                  CONVERGENCE=_F(RESI_GLOB_RELA = 1.E-6,
                                 ITER_GLOB_MAXI = 10),
                  ARCHIVAGE=_F(LIST_INST=LIST_INST,),
                  SIGM_IMPOSE=_F(SIXX=__coef2b,
                                 SIYY=__coef2b,
                                 SIZZ=__coef2b,
                                 SIXY=__coef1b,),
                  SIGM_INIT=_F(SIXX=- 5.E4,
                               SIYY=- 5.E4,
                               SIZZ=- 5.E4,),
                  EPSI_INIT=_F(EPXX=0,
                               EPYY=0,
                               EPZZ=0,
                               EPXY=0,
                               EPXZ=0,
                               EPYZ=0,),);

    Vpyth = __u2.EXTR_TABLE().values();

    SIXX_INI = Vpyth['SIXX'][-1];
    SIYY_INI = Vpyth['SIYY'][-1];
    SIZZ_INI = Vpyth['SIZZ'][-1];
    SIXZ_INI = Vpyth['SIXZ'][-1];
    SIYZ_INI = Vpyth['SIYZ'][-1];
    SIXY_INI = Vpyth['SIXY'][-1];
    EPXX_INI = Vpyth['EPXX'][-1];
    EPYY_INI = Vpyth['EPYY'][-1];
    EPZZ_INI = Vpyth['EPZZ'][-1];
    EPXZ_INI = Vpyth['EPXZ'][-1];
    EPYZ_INI = Vpyth['EPYZ'][-1];
    EPXY_INI = Vpyth['EPXY'][-1];

    VARI_INI=[];

    for i in range(50):
        VARI_INI.append(Vpyth['V'+str(i+1)][-1])

    SPM=SIMU_POINT_MAT(COMPORTEMENT=_F(RELATION='HUJEUX',
                               ITER_INTE_MAXI=20,
                               RESI_INTE_RELA=1E-8,
                               ITER_INTE_PAS =-5,
                               ALGO_INTE='SPECIFIQUE'),
                  MATER=MATER,
                  INCREMENT=_F(LIST_INST=LIST_INST,
                               INST_INIT=TMIL,
                               INST_FIN=TFIN,),
                  NEWTON=_F(MATRICE='TANGENTE',
                            REAC_ITER=1,),
                  CONVERGENCE=_F(RESI_GLOB_RELA = 1.E-6,
                                 ITER_GLOB_MAXI = 10),
                  ARCHIVAGE=_F(LIST_INST=LIST_INST,),
                  SIGM_IMPOSE=_F(SIXX=__coef2b,
                                 SIYY=__coef2b,
                                 SIZZ=__coef2b,
                                 SIXY=__coef1b,),
                  VARI_INIT=_F(VALE=VARI_INI),
                  SIGM_INIT=_F(SIXX=SIXX_INI,
                               SIYY=SIYY_INI,
                               SIZZ=SIZZ_INI,
                               SIXY=SIXY_INI,
                               SIYZ=SIYZ_INI,
                               SIXZ=SIXZ_INI,
                               ),
                   EPSI_INIT=_F(EPXX=EPXX_INI,
                               EPYY=EPYY_INI,
                               EPZZ=EPZZ_INI,
                               EPXY=EPXY_INI,
                               EPXZ=EPXZ_INI,
                               EPYZ=EPYZ_INI,),);
    return SPM

TEST_INIT_cata =MACRO(nom="TEST_INIT", op=test_init_ops,sd_prod=table_sdaster,
                       docu="",reentrant='n',fr="creation d'une charge de rotation du cube",
         TINI            =SIMP(statut='o',typ='R'),
         TMIL            =SIMP(statut='o',typ='R'),
         TFIN            =SIMP(statut='o',typ='R'),
         LIST_INST       =SIMP(statut='o',typ=(listr8_sdaster) ),
         MATER           =SIMP(statut='o',typ=mater_sdaster,max=30),
         )

TEST_INIT = UserMacro("TEST_INIT", TEST_INIT_cata, test_init_ops)


