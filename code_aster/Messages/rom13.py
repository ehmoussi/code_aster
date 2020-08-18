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

# Messages for result management in ROM

from ..Utilities import _

cata_msg = {

    1 : _("""Lecture des paramètres de la structure de données des résultats."""),

    2 : _("""Le champ de type %(k1)s et de numéro d'ordre %(i1)d dans la structure de données des résultats est mis à zéro."""),

   10 : _("""On ne trouve pas de champ de type %(k1)s dans la structure de données des résultats."""),

   11 : _("""Il y a des conditions limites dualisés (AFFE_CHAR_THER ou AFFE_CHAR_MECA) dans le champ de type %(k1)s. Ce n'est pas possible, utilisez AFFE_CHAR_CINE"""),

   50 : _("""Paramètres de la structure de données des résultats."""),

   51 : _("""Type de la structure de données des résultats: %(k1)s."""),

   52 : _("""Nombre de champs enregistrés dans la structure de données des résultats: %(i1)d."""),

   53 : _("""Il y a une table des coordonnées réduites attachée à la structure de données des résultats."""),

   54 : _("""Il n'y a pas de table des coordonnées réduites attachée à la structure de données des résultats."""),

}
