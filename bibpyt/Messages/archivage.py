# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

# person_in_charge: josselin.delmas at edf.fr

# Attention a ne pas faire de retour à la ligne !

cata_msg = {

    1 : _(u"""
 Vous risquez d'écraser des données déjà stockées dans la structure de données résultat.
 Dernier instant stocké dans la structure de données résultat: %(r1)19.12e
 Premier instant du calcul: %(r2)19.12e
"""),

    4 : _(u"""
 Archivage de l'état initial"""),

    5 : _(u"""
  Archivage des champs
"""),

    6 : _(u"""    Champ stocké <%(k1)s> à l'instant %(r1)19.12e pour le numéro d'ordre %(i1)d"""),


}
