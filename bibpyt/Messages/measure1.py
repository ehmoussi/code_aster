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

# Attention a ne pas faire de retour à la ligne !

cata_msg = {

    1  : _("""
  Temps CPU consommé dans ce pas de temps    : %(k1)s
"""),

    2  : _("""
  Temps CPU consommé dans le calcul          : %(k1)s
"""),

    3  : _("""    dont temps CPU "perdu" dans les découpes            : %(k1)s"""),

    6  : _("""    * Temps total factorisation matrice                 : %(k1)s (%(i1)d factorisations)"""),

    7  : _("""    * Temps total intégration comportement              : %(k1)s (%(i1)d intégrations)"""),

    8  : _("""    * Temps total résolution K.U=F                      : %(k1)s (%(i1)d résolutions)"""),

    9  : _("""    * Temps résolution contact                          : %(k1)s (%(i1)d itérations)"""),

    10 : _("""    * Temps appariement contact                         : %(k1)s (%(i1)d appariements)"""),

    11 : _("""    * Temps construction second membre                  : %(k1)s"""),

    12 : _("""    * Temps assemblage matrice                          : %(k1)s"""),

    13 : _("""    * Temps préparation données contact                 : %(k1)s (%(i1)d préparations)"""),

    14 : _("""    * Temps calculs élémentaires contact                : %(k1)s"""),

    15 : _("""    * Temps dans le post-traitement                     : %(k1)s"""),

    16 : _("""    * Temps dans l'archivage                            : %(k1)s"""),

    17 : _("""    * Temps autres opérations                           : %(k1)s"""),

    18 : _("""    * Nombre de liaisons de contact                     : %(i1)d"""),

    19 : _("""    * Nombre de liaisons de frottement adhérentes       : %(i1)d"""),

    20 : _("""    * Nombre de cycles de type contact/pas contact      : %(i1)d"""),

    21 : _("""    * Nombre de cycles de type glissement/adhérence     : %(i1)d"""),

    22 : _("""    * Nombre de cycles de type glissement avant/arrière : %(i1)d"""),

    23 : _("""    * Nombre de cycles de type point fixe contact       : %(i1)d"""),

    24 : _("""    * Nombre d'itérations de recherche linéaire         : %(i1)d"""),

    25 : _("""    * Nombre de pas de temps                            : %(i1)d"""),

    26 : _("""    * Nombre d'itérations de Newton                     : %(i1)d"""),

    27 : _("""    * Temps condensation statique HHO                   : %(k1)s"""),

    28 : _("""    * Temps combinaison HHO                             : %(k1)s"""),

    29 : _("""    * Temps pré-calcul opérateurs HHO                   : %(k1)s"""),
}

