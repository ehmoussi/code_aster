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

# Messages for TABLE management in ROM

from ..Utilities import _

cata_msg = {

    1 : _("""Vérification de la conformité de la table des coordonnées réduites."""),

    2 : _("""Création de la structure de données pour la table contenant les coordonnées réduites."""),

    3 : _("""Sauvegarde des coordonnées réduites dans la table pour le cliché %(i1)d et pour %(i2)d modes."""),

    4 : _("""Sauvegarde des coordonnées réduites dans la table pour le numéro d'ordre %(i1)d (instant: %(r1)19.12e) et pour %(i2)d modes."""),

   23 : _("""Le calcul nécessite de récupérer la table des coordonnées réduites dans la base. On ne l'a pas trouvée.
Si vous récupérez la base d'un fichier externe (LIRE_RESU), il faut donner une table (mot-clef TABL_COOR_REDUIT)."""),

   24 : _("""Le calcul nécessite de récupérer la table des coordonnées réduites dans la base. Cette table existe bien dans mais vous essayez d'utiliser une table externe (TABL_COOR_REDUIT) simultanément, il faut choisir !"""),

   27 : _("""La table des coordonnées réduites est incorrecte car elle n'a pas les bons paramètres."""),

   28 : _("""La table des coordonnées réduites est vide."""),

   29 : _("""La table des coordonnées réduites n'a pas le bon nombre de clichés par rapport à la base."""),

   30 : _("""La table des coordonnées réduites n'a pas le bon nombre de numéros d'ordre par rapport à la base."""),

   31 : _("""La table des coordonnées réduites n'a pas le bon nombre de modes par rapport à la base."""),
}
