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

# person_in_charge: josselin.delmas at edf.fr

from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


CALC_CHAM_ELEM=OPER(nom="CALC_CHAM_ELEM",op=38,sd_prod=cham_elem,
                    fr=tr("Calculer un champ élémentaire en thermique et en accoustique à partir de champs déjà calculés"),
                    reentrant='n',
         MODELE          =SIMP(statut='o',typ=modele_sdaster),
         CARA_ELEM       =SIMP(statut='f',typ=cara_elem),

         regles=(EXCLUS('TOUT','GROUP_MA',),EXCLUS('TOUT','MAILLE',),),
         TOUT            =SIMP(statut='f',typ='TXM',into=("OUI",) ),
         GROUP_MA        =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),
         MAILLE          =SIMP(statut='c',typ=ma  ,validators=NoRepeat(),max='**'),

         INST            =SIMP(statut='f',typ='R',defaut= 0.E+0),
         ACCE            =SIMP(statut='f',typ=cham_no_sdaster),
         MODE_FOURIER    =SIMP(statut='f',typ='I',),

         OPTION          =SIMP(statut='o',typ='TXM',
                               into=("FLUX_ELGA","FLUX_ELNO",
                                                 "PRAC_ELNO",
                                     "COOR_ELGA"), ),

         b_thermique  =BLOC(condition="""is_in("OPTION", ('FLUX_ELNO','FLUX_ELGA',))""",
           TEMP            =SIMP(statut='o',typ=(cham_no_sdaster,)),
           CHAM_MATER      =SIMP(statut='o',typ=cham_mater),
         ),

         b_acoustique  =BLOC(condition="""is_in("OPTION", ('PRAC_ELNO',))""",
           PRES            =SIMP(statut='o',typ=(cham_no_sdaster,)),
         ),

)  ;
