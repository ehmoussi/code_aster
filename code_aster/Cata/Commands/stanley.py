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

# person_in_charge: isabelle.fournier at edf.fr


from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


STANLEY=MACRO(nom="STANLEY",
              op=OPS('Macro.stanley_ops.stanley_ops'),
              sd_prod=None,
              reentrant='n',
              fr=tr("Outil de post-traitement interactif Stanley "),
         RESULTAT        =SIMP(statut='f',typ=(evol_elas,evol_noli,evol_ther,mode_meca,dyna_harmo,dyna_trans) ),
         MODELE          =SIMP(statut='f',typ=modele_sdaster),
         CHAM_MATER      =SIMP(statut='f',typ=cham_mater),
         CARA_ELEM       =SIMP(statut='f',typ=cara_elem),
         DISPLAY         =SIMP(statut='f',typ='TXM'),
         UNITE_VALIDATION=SIMP(statut='f',typ=UnitType(),val_min=10,val_max=90, inout='out',
                               fr=tr("Unité logique définissant le fichier (fort.N) dans lequel on écrit les md5")),

)  ;
