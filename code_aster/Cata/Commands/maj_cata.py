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

# person_in_charge: j-pierre.lefebvre at edf.fr
#
from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


MAJ_CATA=PROC(nom="MAJ_CATA",op=20,
              fr=tr("Compilation des catalogues d'éléments et couverture des calculs élémentaires"),
              regles=(UN_PARMI('ELEMENT','TYPE_ELEM', ),),

              ELEMENT     =FACT(statut='f',),

              UNITE       =SIMP(statut='f',typ=UnitType(),defaut=8, inout='out'),       
              TYPE_ELEM   =FACT(statut='f',),
);
