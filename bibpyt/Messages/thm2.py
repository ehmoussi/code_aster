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
La définition de la température initiale est obligatoire pour une loi de couplage de type %(k1)s.
"""),

    2 : _(u"""
La définition de la deuxième pression initiale est obligatoire pour une loi de couplage de type %(k1)s.
"""),

    3 : _(u"""
La température de référence (exprimée en Kelvin) doit toujours être strictement supérieure à zéro.
"""),

    4 : _(u"""
La pression de gaz de référence doit toujours être différente de zéro.
"""),

    5 : _(u"""
La définition de la température initiale est obligatoire.
"""),

    6 : _(u"""
La température devient négative à la maille %(k1)s.
"""),

}
