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

#
# person_in_charge: jean-luc.flejou at edf.fr
#

from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


IMPR_RESU_SP=MACRO(nom="IMPR_RESU_SP",
    op=OPS('Macro.impr_resu_sp_ops.impr_resu_sp_ops'),
    reentrant='n',
    fr=tr("Sortie des champs à sous-points pour visu avec Salome-Meca"),

    regles=(EXCLUS('INST','LIST_INST','NUME_ORDRE'),),

    # SD résultat et champ à post-traiter :
    RESULTAT   =SIMP(statut='o',typ=evol_noli,fr=tr("RESULTAT à post-traiter."),),
    #
    NUME_ORDRE =SIMP(statut='f',typ='I',validators=NoRepeat(),max='**'),
    INST       =SIMP(statut='f',typ='R',validators=NoRepeat(),max='**'),
    LIST_INST  =SIMP(statut='f',typ=listr8_sdaster),
    #
    GROUP_MA   =SIMP(statut='o',typ=grma,validators=NoRepeat(),max='**'),
    #
    RESU =FACT(statut='o',max='**',
        NOM_CHAM =SIMP(statut='o',typ='TXM',into=("SIEF_ELGA","VARI_ELGA","SIGM_ELGA","SIEQ_ELGA")),
        NOM_CMP  =SIMP(statut='o',typ='TXM',validators=NoRepeat(),max='**',),
    ),
    UNITE =SIMP(statut='o',typ=UnitType(),max=1,min=1, inout='out', fr=tr("Unité du fichier d'archive.")),
)
