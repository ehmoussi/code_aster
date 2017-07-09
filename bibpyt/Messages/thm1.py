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
La loi mécanique <%(k1)s> n'est pas compatible avec la modélisation choisie.
"""),

    2 : _(u"""
La loi de diffusion n'est pas compatible avec la définition de l'élasticité <%(k1)s>.
Les deux doivent être du même type: élasticité isotrope avec diffusion isotrope, élasticité anisotrope avec diffusion anisotrope,
"""),

    3 : _(u"""
On ne peut pas utiliser ELAS_ORTH en 2D, il faut utiliser ELAS_ISTR.
"""),

    4 : _(u"""
On ne peut pas utiliser ELAS_ISTR en 3D, il faut utiliser ELAS_ORTH.
"""),


    35 : _(u"""
La loi de couplage <%(k1)s> n'est pas compatible avec la modélisation choisie <%(k2)s>.
"""),

    36 : _(u"""
Il y a déjà une loi de couplage.
"""),

    37 : _(u"""
Il y a déjà une loi hydraulique.
"""),

    38 : _(u"""
Il y a déjà une loi de mécanique.
"""),

    39 : _(u"""
Il manque la loi de couplage pour définir le kit <%(k1)s> .
"""),

    40 : _(u"""
Il manque la loi hydraulique pour définir le kit <%(k1)s> .
"""),

    41 : _(u"""
Il manque la loi mécanique pour définir le kit <%(k1)s> .
"""),

    42 : _(u"""
La loi de couplage <%(k1)s> est incorrecte pour une modélisation <%(k2)s>.
"""),

    43 : _(u"""
La loi hydraulique <%(k1)s> n'est pas compatible avec la loi mécanique <%(k2)s>.
"""),

    44 : _(u"""
La loi mécanique <%(k1)s> est incorrecte pour une modélisation <%(k2)s>.
"""),

    46 : _(u"""
Il y a une loi mécanique définie dans la relation, ce n'est pas possible avec la modélisation <%(k1)s> .
"""),

    59 : _(u"""
La loi de couplage doit être LIQU_SATU ou GAZ pour une modélisation <%(k1)s>.
"""),

}
