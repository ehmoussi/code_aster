# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

    1 : _("""
La loi mécanique <%(k1)s> n'est pas compatible avec la modélisation choisie.
"""),

    2 : _("""
La loi de diffusion n'est pas compatible avec la définition de l'élasticité <%(k1)s>.
Les deux doivent être du même type: élasticité isotrope avec diffusion isotrope, élasticité anisotrope avec diffusion anisotrope,
"""),

    3 : _("""
On ne peut pas utiliser ELAS_ORTH en 2D, il faut utiliser ELAS_ISTR.
"""),

    4 : _("""
On ne peut pas utiliser ELAS_ISTR en 3D, il faut utiliser ELAS_ORTH.
"""),

    5 : _("""
Le coefficient d'emmagasinement EMMAG n'est pas utilisable avec un couplage mécanique.
"""),

    34 : _("""
 Les conditions initiales de DEFI_MATERIAU (THM_INIT) ne sont pas compatibles avec la loi de couplage choisie dans STAT_NON_LINE.
"""),

    36 : _("""
Il y a déjà une loi de couplage.
"""),

    37 : _("""
Il y a déjà une loi hydraulique.
"""),

    38 : _("""
Il y a déjà une loi de mécanique.
"""),

    39 : _("""
Il manque la loi de couplage pour définir le kit <%(k1)s> .
"""),

    40 : _("""
Il manque la loi hydraulique pour définir le kit <%(k1)s> .
"""),

    42 : _("""
La loi de couplage <%(k1)s> est incorrecte pour une modélisation <%(k2)s>.
"""),

    43 : _("""
La loi hydraulique <%(k1)s> n'est pas compatible avec la loi mécanique <%(k2)s>.
"""),

    44 : _("""
La loi mécanique <%(k1)s> est incorrecte pour une modélisation <%(k2)s>.
"""),

    60 : _("""
La loi de couplage <%(k1)s> n'est pas compatible avec la modélisation choisie.
L'élément a %(i1)d pressions et la loi de couplage en utilise %(i2)d.
"""),

    61 : _("""
La loi de couplage <%(k1)s> n'est pas compatible avec la modélisation choisie.
L'élément a %(i1)d composantes sur la première pression et la loi de couplage en utilise %(i2)d.
"""),

    62 : _("""
La loi de couplage <%(k1)s> n'est pas compatible avec la modélisation choisie.
L'élément a %(i1)d composantes sur la première pression et la loi de couplage en utilise %(i2)d.
"""),

    63 : _("""
La loi de couplage <%(k1)s> n'est pas compatible avec la modélisation choisie.
La modélisation a besoin d'un degré de liberté pour la mécanique.
"""),

    64 : _("""
La loi de couplage <%(k1)s> n'est pas compatible avec la modélisation choisie.
La modélisation a un degré de liberté pour la mécanique la loi de comportement n'a pas de loi mécanique.
"""),

    65 : _("""
La loi de couplage <%(k1)s> n'est pas compatible avec la modélisation choisie.
La modélisation a besoin d'un degré de liberté pour la thermique.
"""),

    66 : _("""
La loi de couplage <%(k1)s> n'est pas compatible avec la modélisation choisie.
La modélisation a un degré de liberté pour la thermique la loi de comportement n'a pas de loi thermique.
"""),

    67 : _("""
La loi mécanique GONF_ELAS n'est utilisable qu'avec une modélisation à deux pressions.
"""),

    94 : _("""Il manque les paramètres de Van Genuchten."""),

}
