# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 2018 Aether Engineering Solutions - www.aethereng.com
# Copyright (C) 2018 Kobe Innovation Engineering - www.kobe-ie.com
# Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
# aslint: disable=W4004

cata_msg = {
1 : _(u"""
 -> Vous avez demandé ...................... CODIFICATION = "UTILISATEUR"
 -> En cette version la seule valeur disponible est "EC2". Le calcun
    ne sera pas effectué pour les autres valeurs.
"""),

2 : _(u"""
 -> Vous avez demandé ........................ TYPE_STRUCTURE = "POUTRE"
 -> En cette version la seule valeur disponible est "2D". Le calcul pour
    ne sera pas effectué pour les autres valeurs.
"""),

3 : _(u"""
 -> Vous avez demandé ....................... TYPE_STRUCTURE = "POTEAU"
 -> En cette version la seule valeur disponible est "2D". Le calcul pour
    ne sera pas effectué pour les autres valeurs.
"""),

4 : _(u"""
 -> La liste NUME_ORDRE contient au moins une valeur répétée.
"""),

5 : _(u"""
 -> La liste NOM_CAS contient au moins une valeur répétée.
"""),

6 : _(u"""
 -> Un NOM_CAS indiqué n'appartient pas aux cas disponibles
"""),

7 : _(u"""
 -> Un NUME_ORDRE indiqué n'appartient pas aux cas disponibles
"""),

8 : _(u"""
 -> L'utilisation de COMBINAISON_FERRAILLAGE n'est possible qu'avec un seul
 -> MODELE
"""),

9 : _(u"""
 -> Le cas COMB_DIME_ORDRE existe déjà. Il sera écrasé !!!
"""),

10 : _(u"""
 -> Le cas COMB_DIME_ACIER existe déjà. Il sera écrasé !!!
"""),
}
