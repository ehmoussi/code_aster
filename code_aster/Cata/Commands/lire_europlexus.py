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

# person_in_charge: serguei.potapov at edf.fr

from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


LIRE_EUROPLEXUS = MACRO(nom="LIRE_EUROPLEXUS",
                        op=OPS('Macro.lire_europlexus_ops.lire_europlexus_ops'),
                        sd_prod=evol_noli,
                        reentrant='n',
                        fr="Chainage Code_Aster-Europlexus",

        UNITE_MED = SIMP(statut='o', typ=UnitType('med'), inout='in',),
        MODELE      = SIMP(statut='o',typ=modele_sdaster),
        CARA_ELEM   = SIMP(statut='f',typ=cara_elem),
        CHAM_MATER  = SIMP(statut='f',typ=cham_mater),
        COMPORTEMENT  =C_COMPORTEMENT('CALC_EUROPLEXUS'),
        EXCIT       = FACT(statut='f',max='**',
           CHARGE         = SIMP(statut='o',typ=(char_meca,)),
           FONC_MULT      = SIMP(statut='f',typ=(fonction_sdaster,)),
          ),
        INFO        = SIMP(statut='f',typ='I',defaut=1,into=( 1, 2 ) ),
        ) ;
