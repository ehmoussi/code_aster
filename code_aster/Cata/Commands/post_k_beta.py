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

# person_in_charge: david.haboussa at edf.fr
#
from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


POST_K_BETA=OPER(nom="POST_K_BETA",op=198,sd_prod=table_sdaster,
                   fr=tr("Calcul des facteurs d'intensité de contraintes par la méthode K_BETA"),
                   reentrant='n',
         MAILLAGE      = SIMP(statut='o',typ=maillage_sdaster),
         MATER_REV     = SIMP(statut='o',typ=mater_sdaster),
         EPAIS_REV     = SIMP(statut='f',typ='R'),
         MATER_MDB     = SIMP(statut='f',typ=mater_sdaster),
         EPAIS_MDB     = SIMP(statut='f',typ='R'),
         FISSURE       = FACT(statut='o',
            FORM_FISS      =SIMP(statut='o',typ='TXM',defaut="ELLIPSE",
                                 into=("ELLIPSE","SEMI_ELLIPSE") ),
            b_fissure=BLOC(condition="""equal_to("FORM_FISS", 'ELLIPSE')""",
              DECALAGE       = SIMP(statut='f',typ='R',defaut=-2.e-04),
            ),
            PROFONDEUR     = SIMP(statut='o',typ='R'),
            LONGUEUR       = SIMP(statut='o',typ='R'),
            ORIENTATION    = SIMP(statut='o',typ='TXM',
                                 into=("CIRC","LONGI"),),
         ),
         K1D           = FACT(statut='o',max='**',
            TABL_MECA_REV  = SIMP(statut='f',typ=(table_sdaster)),
            TABL_MECA_MDB  = SIMP(statut='o',typ=(table_sdaster)),
            TABL_THER      = SIMP(statut='o',typ=(table_sdaster)),
            INTITULE       = SIMP(statut='o',typ='TXM' ),
         ),
         TITRE         = SIMP(statut='f',typ='TXM'),
);
