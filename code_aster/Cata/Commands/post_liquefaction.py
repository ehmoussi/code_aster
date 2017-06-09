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

from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


POST_LIQUEFACTION=MACRO(nom="POST_LIQUEFACTION",
                        op=OPS("Macro.post_liquefaction_ops.post_liquefaction_ops"),
                        sd_prod=evol_noli,
                        reentrant='n',
                        AXE      = SIMP(statut='o',typ='TXM',into=("X","Y","Z"),max=1),
                        RESU_REF = SIMP(statut='o',typ=evol_noli,),
                        INST_REF = SIMP(statut='o',typ='R'),
                        RESULTAT = SIMP(statut='o',typ=evol_noli,), 
) ;
