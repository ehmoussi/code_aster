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
 Pour calculer l'aire, les mailles décrivant le contour doivent être du type SEG2 ou SEG3.
 Or la maille  %(k1)s est de type  %(k2)s.
"""),

    2 : _(u"""
 Le contour dont on doit calculer l'aire n'est pas fermé.
"""),

    3 : _(u"""
 Il n'y a aucun élément lors de la lecture du mot-clef facteur %(k1)s.
"""),

    4 : _(u"""
 Il n'y a aucun noeud lors de la lecture du mot-clef facteur %(k1)s.
"""),
}
