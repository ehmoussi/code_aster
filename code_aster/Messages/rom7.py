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

   2  : _("""Création d'une base empirique à partir de champs de type %(k1)s."""),

   3  : _("""Tolérance pour les valeurs singulières: %(r1)13.6G."""),

   6  : _("""Initialisation de l'algorithme."""),

   7  : _("""Vérifications des paramètres."""),

   9  : _("""Calcul de la base empirique."""),

   10 : _("""Consommation mémoire de la SVD: %(i1)d octets."""),

   12 : _("""Calcul des coordonnées réduites."""),

   13 : _("""Tolérance pour l'algorithme incrémental: %(r1)13.6G."""),

   14 : _("""Nombre final de clichés retenus dans l'algorithme incrémental: %(i1)d."""),

   15 : _("""Enrichissement de la base empirique."""),

   16 : _("""Création de nouveaux modes empiriques."""),

   20 : _("""Paramètres spécifiques à la méthode POD ou POD_INCR."""),

   21 : _("""Paramètres spécifiques à la méthode GLOUTON."""),

   22 : _("""Paramètres spécifiques à la méthode de troncature."""),

   23 : _("""Le calcul de type POD_INCR nécessite de récupérer la table des coordonnées réduites dans la base.
Conseil: si vous récupérez la base d'un fichier externe (LIRE_RESU), ça ne peut pas fonctionner, il faut que la création de la base soit dans la même étude."""),

   24 : _("""Le calcul de type POD_INCR nécessite de récupérer la table des coordonnées réduites dans la base. Cette table existe bien dans mais vous essayez d'utiliser une table externe (TABL_COOR_REDUIT). Supprimer ce paramètre.
"""),

   25 : _("""Vous demandez à calculer un champ de type %(k1)s par REST_REDUIT_COMPLET alors que ce champ n'existe pas dans le résultat réduit.
Conseil: utilisez CALC_CHAMP pour calculer ce champ."""),

   26 : _("""Une table des coordonnées réduites a été fournie par l'utilisateur."""),

   27 : _("""La table des coordonnées réduites fournie par l'utilisateur est incorrecte car elle n'a pas les bons paramètres."""),

   28 : _("""La table des coordonnées réduites fournie par l'utilisateur est vide."""),

   29 : _("""La table des coordonnées réduites n'a pas le bon nombre de clichés par rapport à la base empirique."""),

   30 : _("""La table des coordonnées réduites n'a pas le bon nombre de modes par rapport à la base empirique."""),

   31 : _("""Paramètres spécifiques à la méthode d'orthogonalisation."""),

   32 : _("""Paramètre pour l'algorithme: %(r1)13.6G."""),

}
