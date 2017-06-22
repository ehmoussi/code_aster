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

cata_msg = {

    79 : _(u"""
   Arrêt par manque de temps CPU pendant les itérations de Newton, au numéro d'instant < %(i1)d >
      - Temps moyen par itération de Newton : %(r1)f
      - Temps restant                       : %(r2)f

   La base globale est sauvegardée. Elle contient les pas archivés avant l'arrêt.
"""),

    80 : _(u"""
   Arrêt par manque de temps CPU au numéro d'instant < %(i1)d >
      - Temps moyen par pas de temps        : %(r1)f
      - Temps restant                       : %(r2)f

   La base globale est sauvegardée. Elle contient les pas archivés avant l'arrêt.
"""),
}
