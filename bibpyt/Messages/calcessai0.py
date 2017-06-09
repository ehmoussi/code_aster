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

# person_in_charge: albert.alarcon at edf.fr

cata_msg = {

    1: _(u"""
Le modèle mesuré doit être un concept de type DYNA_HARMO ou MODE_MECA.
"""),

    3: _(u"""
Calcul de MAC impossible : bases incompatibles.
"""),

    4: _(u"""
Problème inverse impossible : problème de cohérence entre les données.
"""),

    5: _(u"""
Problème de NUME_DDL dans MACRO_EXPANS : il est possible de le préciser
a l'appel de la macro-commande. Conséquence : erreur fatale possible dans les
opérations ultérieures (notamment l'opérateur MAC_MODE)
"""),

    6: _(u"""
Si vous n'avez pas sélectionné de NUME_ORDRE ou de NUME_MODE dans %(k1)s.
Il ne faut pas déclarer de concept en sortie de type %(k2)s.
Cela risque de causer une erreur fatale par la suite.
"""),

    7: _(u"""
Erreur dans MACRO_EXPANS
"""),

    8: _(u"""
Impossible de trouver le modèle associe a la base de modes %(k1)s.
Cela peut empêcher certains calculs de se dérouler normalement.
"""),

    9: _(u"""
Les mots-clés MATR_RIGI et MATR_MASS n'ont pas été renseignés dans OBSERVATION.
Sans ces matrices, certains calculs (par exemple : calcul d'expansion, de MAC, etc.)
ne seront pas possibles.
"""),

    10: _(u"""
Le modèle associé aux matrices MATR_RIGI et MATR_MASS doit être le même que MODELE_2.
"""),

    13: _(u"""
Le résultat expérimental est un DYNA_HARMO : il n'est pas possible d'en extraire
des numéros d'ordre avec MACRO_EXPANS. Le mots-clés NUME_MODE et NUME_ORDRE
sont ignorés.
"""),

    14: _(u"""
Erreur dans le calcul de MAC : le NUME_DDL associé à la base %(k1)s
n'existe pas. Si cette base a été créée avec PROJ_CHAMP, ne pas oublier
de mentionner explicitement le NUME_DDL de la structure de données résultat
avec le mot-clé NUME_DDL.
"""),


}
