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
import math

from code_aster.Cata.DataStructure import (cham_mater, cham_no_sdaster,
                                           char_meca, listr8_sdaster,
                                           maillage_sdaster, modele_sdaster,
                                           resultat_sdaster)
from code_aster.Cata.Syntax import _F, MACRO, SIMP
from code_aster.Commands import (AFFE_CHAR_MECA_F, CALC_FONC_INTERP, CREA_CHAMP,
                                 DEFI_LIST_REEL, DETRUIRE, FORMULE)
from code_aster.Supervis.ExecuteCommand import UserMacro


def char_rota_ops(self,MODELE,ANGLE_DEGRES,TINI,TFIN,RESU,MAIL,**args):
    import numpy as NP

    angle=ANGLE_DEGRES*math.pi/180.0
    coordo=MAIL.sdj.COORDO.VALE.get()
    nomnoe=MAIL.sdj.NOMNOE.get()
    coordo=NP.reshape(coordo,[len(coordo)//3,3])
    X=coordo[:,0]
    Y=coordo[:,1]

    __interp=DEFI_LIST_REEL(DEBUT=TINI,INTERVALLE=_F(JUSQU_A=TFIN,NOMBRE=1000))
    __DEPL1=CREA_CHAMP( OPERATION='EXTR',TYPE_CHAM='NOEU_DEPL_R',NOM_CHAM='DEPL',RESULTAT=RESU,INST=TINI)
    dx=__DEPL1.EXTR_COMP("DX",[],1).valeurs
    dy=__DEPL1.EXTR_COMP("DY",[],1).valeurs
    ddlimpo=[]

    for ino in [0,2,3]:
        X1=X[ino]+dx[ino]
        Y1=Y[ino]+dy[ino]
        const_context = {
            'X1' : X1, 'Y1' : Y1 , 'angle' : angle, 'TFIN' : TFIN, 'TINI' : TINI
        }
        __DXTf = FORMULE(VALE='X1*(cos(angle*(INST-TINI)/(TFIN-TINI))-1.0)-Y1*sin(angle*(INST-TINI)/(TFIN-TINI))',
                         NOM_PARA=('INST'),
                         **const_context)
        _DXT  =CALC_FONC_INTERP( FONCTION=__DXTf,LIST_PARA=__interp,NOM_PARA='INST',INTERPOL='LIN')
        __DYTf = FORMULE(VALE='X1*sin(angle*(INST-TINI)/(TFIN-TINI))+Y1*(cos(angle*(INST-TINI)/(TFIN-TINI))-1.0)',
                         NOM_PARA=('INST'),
                         **const_context)
        _DYT  =CALC_FONC_INTERP( FONCTION=__DYTf,LIST_PARA=__interp,NOM_PARA='INST',INTERPOL='LIN')
        dico={}
        dico["NOEUD"]=nomnoe[ino]
        dico["DX"]=_DXT
        dico["DY"]=_DYT
        ddlimpo.append(dico)
    CharRota=AFFE_CHAR_MECA_F(MODELE=MODELE,DDL_IMPO=ddlimpo)
    return CharRota

CHAR_ROTA_cata =MACRO(nom="CHAR_ROTA", op=char_rota_ops,sd_prod=char_meca,
                       docu="",reentrant='n',fr="creation d'une charge de rotation du cube",
         MODELE           =SIMP(statut='o',typ=modele_sdaster),
         ANGLE_DEGRES     =SIMP(statut='o',typ='R'),
         TINI             =SIMP(statut='o',typ='R'),
         TFIN             =SIMP(statut='o',typ='R'),
         RESU             =SIMP(statut='o',typ=resultat_sdaster,fr="Résultat de STAT_NON_LINE"),
         MAIL             =SIMP(statut='o',typ=maillage_sdaster,),
         )

CHAR_ROTA = UserMacro("CHAR_ROTA", CHAR_ROTA_cata, char_rota_ops)
