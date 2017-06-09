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

# Attention a ne pas faire de retour à la ligne !

cata_msg = {

    1  : _(u"""
  Temps CPU consommé dans ce pas de temps    : %(k1)s
"""),

    2  : _(u"""
  Temps CPU consommé dans le calcul          : %(k1)s
"""),

    3  : _(u"""    dont temps CPU "perdu" dans les découpes            : %(k1)s"""),

    6  : _(u"""    * Temps total factorisation matrice                 : %(k1)s (%(i1)d factorisations)"""),

    7  : _(u"""    * Temps total intégration comportement              : %(k1)s (%(i1)d intégrations)"""),

    8  : _(u"""    * Temps total résolution K.U=F                      : %(k1)s (%(i1)d résolutions)"""),

    9  : _(u"""    * Temps résolution contact                          : %(k1)s (%(i1)d itérations)"""),

    10 : _(u"""    * Temps appariement contact                         : %(k1)s (%(i1)d appariements)"""),

    11 : _(u"""    * Temps construction second membre                  : %(k1)s"""),

    12 : _(u"""    * Temps assemblage matrice                          : %(k1)s"""),

    13 : _(u"""    * Temps préparation données contact                 : %(k1)s (%(i1)d préparations)"""),

    14 : _(u"""    * Temps calculs élémentaires contact                : %(k1)s"""),

    15 : _(u"""    * Temps dans le post-traitement                     : %(k1)s"""),

    16 : _(u"""    * Temps dans l'archivage                            : %(k1)s"""),

    17 : _(u"""    * Temps autres opérations                           : %(k1)s"""),

    18 : _(u"""    * Nombre de liaisons de contact                     : %(i1)d"""),

    19 : _(u"""    * Nombre de liaisons de frottement adhérentes       : %(i1)d"""),

    20 : _(u"""    * Nombre de cycles de type contact/pas contact      : %(i1)d"""),

    21 : _(u"""    * Nombre de cycles de type glissement/adhérence     : %(i1)d"""),

    22 : _(u"""    * Nombre de cycles de type glissement avant/arrière : %(i1)d"""),

    23 : _(u"""    * Nombre de cycles de type point fixe contact       : %(i1)d"""),

    24 : _(u"""    * Nombre d'itérations de recherche linéaire         : %(i1)d"""),

    25 : _(u"""    * Nombre de pas de temps                            : %(i1)d"""),

    26 : _(u"""    * Nombre d'itérations de Newton                     : %(i1)d"""),

}
