# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

# person_in_charge: nicolas.greffet at edf.fr
#
#  ENVOI DES CHAMPS CINEMATIQUES VIA YACS POUR COUPLAGE IFS
#

from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


ENV_CINE_YACS=PROC(nom             = "ENV_CINE_YACS",
                   op              = 111,
                   fr              = tr("Envoi des champs de deplacement et vitesse via YACS pour Couplage de Code_Aster et Saturne"),
                   regles          = (EXCLUS('ETAT_INIT','RESULTAT',),),
                   MATR_PROJECTION = SIMP(statut='o', typ=corresp_2_mailla,),
                   VIS_A_VIS = FACT(statut='o', max='**',
                                   GROUP_MA_1=SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
                                   GROUP_NO_2=SIMP(statut='f',typ=grno,validators=NoRepeat(),max='**'),),
                   RESULTAT  = FACT(statut='f',
                                   NUME_ORDRE=SIMP(statut='o', typ='I',              validators=NoRepeat()),
                                   RESU      =SIMP(statut='o', typ=resultat_sdaster, validators=NoRepeat()),),
                   ETAT_INIT = FACT(statut='f',
                                    DEPL=SIMP(statut='f', typ=cham_no_sdaster,  validators=NoRepeat()),
                                    VITE=SIMP(statut='f', typ=cham_no_sdaster,  validators=NoRepeat()),
                                    ACCE=SIMP(statut='f', typ=cham_no_sdaster,  validators=NoRepeat()),),
                   INST         = SIMP(statut='o',typ='R', ),
                   PAS             = SIMP(statut='o',typ='R', ),
                   NUME_ORDRE_YACS = SIMP(statut='o', typ='I',),
                   INFO            = SIMP(statut='f',typ='I',defaut=1,into=(1,2) ),
) ;
