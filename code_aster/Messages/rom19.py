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

# Messages for all commands in ROM (generic)

cata_msg = {

    1 : _("""Initialisation des structures de données."""),

    2 : _("""Lecture des paramètres de la commande."""),

    3 : _("""Vérification des paramètres de la commande."""),
 
    4 : _("""Initialisation de la base à créer."""),
 
    5 : _("""Initialisation de l'algorithme."""),

    6 : _("""Paramètres généraux de la commande pour la méthode %(k1)s."""),

    7 : _("""On modifie une base déjà existante."""),

    8 : _("""On crée une nouvelle base."""),

    9 : _("""Calcul de la base."""),

}
