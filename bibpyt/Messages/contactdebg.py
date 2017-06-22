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

# person_in_charge: mickael.abbas at edf.fr

cata_msg = {



    11: _(u"""
 <CONTACT_2> Le noeud <%(k1)s> n'est pas apparié car il aurait été projeté hors de la zone de tolérance de la maille <%(k2)s> qui était la plus proche.
 <CONTACT_2> Vous pouvez éventuellement modifier TOLE_PROJ_EXT ou revoir la définition de vos zones esclaves et maîtres.
"""),

    12: _(u"""
 <CONTACT_2> Le noeud <%(k1)s> n'est pas apparié car aucun noeud n'est dans sa zone TOLE_APPA.
"""),

    13: _(u"""
 <CONTACT_2> Le noeud <%(k1)s> n'est pas apparié car il appartient a SANS_NOEUD ou SANS_GROUP_NO.
"""),



}
