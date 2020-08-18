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

# Messages for field management in ROM

from ..Utilities import _

cata_msg = {

    1 : _("""Le champ a pour support %(k1)s, ce qui n'est pas autorisé."""),

    7 : _("""Création de la liste des noeuds à partir de la liste des équations."""),

    8 : _("""Détection des équations définies pour les noeuds donnés."""),

   11 : _("""On n'a pas réussi à extraire le champ de type %(k1)s pour le numéro d'ordre %(i1)d dans la structure de données résultat."""),

   23 : _("""Le champ contient la composante %(k1)s qui n'est pas autorisée. Vous utilisez un modèle qui n'est pas compatible avec la réduction de modèle."""),

   25 : _("""Le champ ne contient pas la composante %(k1)s. Vous utilisez un modèle qui n'est pas compatible avec la réduction de modèle."""),

   35 : _("""Le champ a un nombre de composantes par noeud qui n'est pas constant."""),

   37 : _("""Préparation de la relation entre les équations de deux domaines."""),

   50 : _("""Le champ est de type %(k1)s."""),

   51 : _("""Le champ contient %(i1)d équations."""),

   52 : _("""Le champ est défini sur les noeuds."""),

   53 : _("""Le champ est défini sur les points d'intégration ."""),

   54 : _("""Le champ contient %(i1)d composantes."""),

   55 : _("""Nom de la composante %(i1)d: %(k1)s."""),

   56 : _("""Le champ contient des multiplicateurs de Lagrange."""),

}
