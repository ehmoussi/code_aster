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
    1  : _("""Le modèle de déformation %(k1)s n'est pas possible avec des éléments linéaires sous-intégrés."""),

    2  : _("""Le seul comportement élastique valide est ELAS pour les éléments linéaires sous-intégrés."""),

    3  : _("""Les comportements écrits en configuration de référence ne sont pas disponibles sur les éléments linéaires pour la modélisation 3D_SI.
Pour contourner le problème et passer à un comportement en configuration actuelle, ajoutez un état initial nul au calcul.
"""),

}
