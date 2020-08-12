# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

from ..Utilities import _

cata_msg = {

    1 : _("""Il faut autant de noms pour NOM_CHAM_MED que pour NOM_CHAM."""),

    2 : _("""Le nom utilisateur n'a pas été trouvé, on utilise le nom automatique à la place %(k1)s.

            Ceci peut engendrer des problèmes lors du post-traitement avec PARAVIS.
            Il est possible de changer manuellement le nom avec NOM_CHAM_MED et NOM_RESU_MED.
          """),

    6 : _("""On ne peut pas donner les noms des composantes du champ (NOM_CMP) quand on utilise le nom du résultat MED (NOM_RESU_MED)."""),


}
