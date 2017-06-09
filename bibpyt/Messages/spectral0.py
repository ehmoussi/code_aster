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

    2: _(u"""
%(k1)s: FREQ_MAX < FREQ_MIN
"""),

    3: _(u"""
Erreur dans les indices.
"""),

    4: _(u"""
Le fichier %(k1)s est introuvable.
"""),

    5: _(u"""
La dimension DIM n est pas précisée dans le fichier lu.
"""),

    6: _(u"""
Nombre de fonctions incorrect.
"""),

    7: _(u"""
Erreur dans les données de fonctions.
"""),

    9: _(u"""
Le fichier IDEAS est vide ou ne contient pas le data set demande
"""),

    10: _(u"""
Un des data sets 58 contient une donnée qui n'est pas un interspectre
"""),

    11: _(u"""
On ne traite pas les cas ou les abscisses fréquentielles ne sont pas régulièrement espacées
"""),

    12: _(u"""
Le mot-clé format correspond au format du fichier source, qui peut être 'ASTER' ou 'IDEAS' (pour lire les DS58)
"""),

    13: _(u"""
Le calcul en multi-appuis n'est réalisable que lorsque le concept résultat renseigné sous le mot-clé RESU est RESU_GENE.
"""),

14: _(u"""
Les listes données pour AMOR_EQUIP, FREQ_EQUIP et COEF_MASS_EQUIP doivent être de même longueur
"""),

15: _(u"""
La somme des rapport de masses COEF_MASS_EQUIP doit être égale à 1
"""),

16: _(u"""
La valeur initiale du signal d'entrée dépasse le critère limite TOLE_INIT choisi %(r1)f > %(r2)f
"""),

17: _(u"""
La table fournie ne comporte pas le paramètre %(k1)s. Elle n'est pas issue de MACR_SPECTRE. 
"""),

18: _(u"""
Les valeurs des amortissements de deux instances de SPECTRE sont différentes. 
"""),

19: _(u"""
Les impressions de figures ne peuvent pas être faites car il manque une bibliothèque.

Cette librairie est disponible en lançant le calcul depuis Salome-Meca.
"""),

20: _(u"""
Le mot-clé ELARG n'a pas d'effet avec l'option CONCEPTION. 
"""),

}
