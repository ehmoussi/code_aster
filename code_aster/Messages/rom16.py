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

# Messages for REST_REDUIT_COMPLET

cata_msg = {

    1 : _("""Lecture des paramètres de la commande."""),

    2 : _("""Initialisations pour le post-traitement du calcul réduit."""),

    3 : _("""Reconstruction des champs sur tout le domaine."""),

   20 : _("""Les bases ne sont pas définies sur le même maillage."""),

   21 : _("""Les bases ne sont pas définies sur le même modèle."""),

   22 : _("""Le modèle d'une des bases n'est pas celui du modèle complet. Vérifiez que vous n'utilisez pas la base tronquée."""),

   23 : _("""Le modèle est le même pour la reconstruction que le modèle réduit d'origine."""),

   24 : _("""Vous demandez à calculer un champ de type %(k1)s par REST_REDUIT_COMPLET alors que ce champ n'existe pas dans le résultat réduit.
Conseil: utilisez CALC_CHAMP pour calculer ce champ."""),

   50 : _("""Le résultat sur le modèle complet sera de type %(k1)s."""),

   51 : _("""Le résultat sur le modèle réduit contient %(i1)d numéros d'ordre."""),

   52 : _("""On évalue le champ dual."""),

   53 : _("""Correction par le calcul éléments finis."""),

}
