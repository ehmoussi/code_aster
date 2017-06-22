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

#

cata_msg = {


    39 : _(u"""
 Le modèle contient des éléments de structure, il faut probablement utiliser le mot-clé CARA_ELEM.
 Risque & Conseil :
     Ce message peut aider à comprendre un éventuel problème ultérieur lors de calculs élémentaires
     nécessitant des caractéristiques pour les éléments de structure.
     Vérifiez si votre modélisation nécessite un CARA_ELEM.
"""),

    40 : _(u"""
 Le modèle a probablement besoin d'un champ de matériau (mot-clé CHAM_MATER).
 Risque & Conseil :
     Ce message peut aider à comprendre un éventuel problème ultérieur lors de calculs élémentaires
     nécessitant des caractéristiques matérielles.
     Vérifiez si votre modélisation nécessite un CHAM_MATER.
"""),
}
