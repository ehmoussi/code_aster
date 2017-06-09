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
#  RECUPERATION DES EFFORTS VIA YACS POUR COUPLAGE IFS
#

from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


MODI_CHAR_YACS=OPER(nom            = "MODI_CHAR_YACS",
                   op              = 112,
                   sd_prod         = char_meca,
                   reentrant       = 'o',
                   fr              = tr("Reception des forces nodales via YACS lors du couplage de  Code_Aster et Saturne"),
                   CHAR_MECA       = SIMP(statut ='o', typ = char_meca),
                   MATR_PROJECTION = SIMP(statut ='o', typ = corresp_2_mailla,),
                   NOM_CMP_IFS     = SIMP(statut ='o', typ = 'TXM',validators = NoRepeat(), max = '**'),
                   VIS_A_VIS       = FACT(statut ='o', max = '**',
                                   GROUP_MA_1 = SIMP(statut='o',typ=grma,validators=NoRepeat(),max='**'),
                                   GROUP_NO_2 = SIMP(statut='o',typ=grno,validators=NoRepeat(),max='**'),),
                   INST            = SIMP(statut='o',typ='R', ),
                   PAS             = SIMP(statut='o',typ='R', ),
                   NUME_ORDRE_YACS = SIMP(statut='o', typ='I',),
                   INFO            = SIMP(statut='f',typ='I',defaut=1,into=(1,2) ),
);
