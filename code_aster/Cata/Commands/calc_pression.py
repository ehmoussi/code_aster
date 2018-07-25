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

# Le calcul de la pression sur une interface est utilie en mécanique notamment
# en mécanique de contact, mécanique de la rupture,....
# Cette routine produit un cham_gd calculé à partir du tenseur de contraintes nodale SIEF_NOEU
# L'option n'existe que pour les éléments isoparamétriques mais elle pourra être étendue
# au frottement et aux éléments de structures si le besoin se manifeste.


from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


CALC_PRESSION=MACRO(nom="CALC_PRESSION",
                    op=OPS('Macro.calc_pression_ops.calc_pression_ops'),
                    sd_prod=cham_no_sdaster,
                    fr="Calcul de la pression nodale sur une interface a partir de SIEF_NOEU. Cette option n existe que pour les éléments isoparamétriques.",

         MAILLAGE        =SIMP(statut='o',typ=maillage_sdaster),
         RESULTAT        =SIMP(statut='o',typ=(evol_elas,evol_noli)),
         GROUP_MA        =SIMP(statut='o',typ=grma ,validators=NoRepeat(),max='**'),
         INST            =SIMP(statut='o',typ='R',max='**'),
         MODELE          =SIMP(statut='f',typ=modele_sdaster),
         GEOMETRIE      = SIMP(statut='f',typ='TXM',defaut="INITIALE",into=("INITIALE","DEFORMEE")),
         INFO            =SIMP(statut='f',typ='I',defaut=1,into=(1,2)),
);
