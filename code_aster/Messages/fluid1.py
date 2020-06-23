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

    1  : _("""Le comportement ne peut être qu'élastique sur une modélisation de type 3D_FLUIDE, AXIS_FLUIDE ou 2D_FLUIDE."""),

    2  : _("""Le calcul de l'option n'est pas possible avec la formulation %(k1)s. Il faut demander une évolution."""),

    3  : _("""On n'a pas trouvé d'élément fluide en regard de l'élément d'interaction fluide-structure. On ne peut donc pas vérifier les normales."""),

    4  : _("""Certaines normales entre fluide et structure ne sont pas orientées dans le bon sens."""),
}
