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

# person_in_charge: ayaovi-dzifa.kudawoo at edf.fr


from code_aster.Utilities import _

cata_msg = {

    1 : _("""
Cette maille n'est pas valable pour la méthode LAC de contact.
"""),

    2 : _("""
Vous essayer de faire un MODI_MAILLAGE après avoir fait CREA_MAILLAGE/DECOUPE_LAC sur ce même maillage.
C'est interdit sauf pour les mots clés DEFORME et TRANSLATION uniquement.

Conseil: Effectuez toutes les opérations MODI_MAILLAGE avant d'effectuer CREA_MAILLAGE/DECOUPE_LAC sur votre maillage.
"""),
}
