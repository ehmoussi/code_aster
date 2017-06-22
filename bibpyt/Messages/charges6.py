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

    1 : _(u"""
 Pour le chargement thermique ECHANGE_PAROI, le type de maille utilisé n'est pas possible.
 Vérifiez que vous avez correctement défini la paroi.
"""),

    2 : _(u"""
 Pour le chargement thermique ECHANGE_PAROI, le modèle fourni doit être homogène
 en dimension : 3D, 2D ou AXIS.
"""),

    3 : _(u"""
 Les chargements thermiques de type EVOL_CHAR ne sont pas pris en compte dans cet opérateur.
"""),
}
