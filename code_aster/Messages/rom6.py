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

# person_in_charge: mickael.abbas at edf.fr

from ..Utilities import _

cata_msg = {

   12 : _("""La base empirique est construite sur un maillage différent du modèle. Ce n'est pas possible."""),

   13 : _("""Les deux modèles sont identiques, on ne peut rien tronquer !"""),

   31 : _("""Calcul des coordonnées réduites."""),

   32 : _("""Échec lors du calcul des coordonnées réduites."""),

   40 : _("""Vous avez donné le nom de la base à tronquer (BASE_INIT) alors que vous voulez tronquer une base déjà existante."""),
}
