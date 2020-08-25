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

# Messages for FIELD BUILD management in ROM

from ..Utilities import _

cata_msg = {

    1 : _("""Initialisations pour le champ %(k1)s."""),

    2 : _("""Préparation des objets pour la numérotation."""),

    3 : _("""Troncature de la matrice des modes.
 Dimensions initiales: [%(i1)d,%(i2)d]
 Dimensions finales  : [%(i3)d,%(i4)d]"""),

    4 : _("""Préparation des coordonnées réduites par reconstruction partielle."""),

    5 : _("""Préparation des coordonnées réduites par récupération directe dans la table des coordonnées réduites."""),

    6 : _("""Construction du champ complet sur tous les pas de temps."""),

    7 : _("""Calcul pour le champ %(k1)s."""),

    8 : _("""Calcul des coordonnées réduites."""),

    9 : _("""Échec lors du calcul des coordonnées réduites. Les modes sont peut-être colinéaires."""),
}
