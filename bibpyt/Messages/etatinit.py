# coding=utf-8
# --------------------------------------------------------------------
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

# Attention a ne pas faire de retour à la ligne !

cata_msg = {

    1 : _(u"""
 On utilise l'opérateur en enrichissant les résultats (REUSE).
 Mais on ne définit pas d'état initial: on prend un état initial nul.
"""),

    3 : _(u"""
 L'instant spécifié sous ETAT_INIT/INST n'est pas trouvé dans la structure de données
 résultat de nom <%(k1)s>.
"""),

    4 : _(u"""
 Il y a plusieurs instants dans la structure de données résultat de nom <%(k1)s> qui
 correspondent à celui spécifié sous ETAT_INIT/INIT.
"""),

    5 : _(u"""
 A l'instant initial, tous les termes du bilan d'énergie sont nuls bien qu'un état
 initial non vierge soit renseigné. Le bilan d'énergie indique la variation des différents
 termes d'énergie entre deux instants de calcul consécutifs ainsi que leur variation
 totale entre l'instant courant et l'instant initial.
"""),

    10 : _(u"""    Lecture de l'état initial"""),

    11 : _(u"""      L'état initial a été récupéré dans la structure de données résultat de nom <%(k1)s> pour le numéro d'ordre %(i1)d et à l'instant %(r1)19.12e"""),

    12 : _(u"""      L'instant initial est défini par INST_ETAT_INIT et vaut %(r1)19.12e """),

    20 : _(u"""      Il n'y a pas d'état initial défini. On prend un état initial nul."""),

    30 : _(u"""
  Le champ %(k1)s n'est pas trouvé dans ETAT_INIT et on ne sait pas l'initialiser à zéro.
"""),

    31 : _(u"""      Le champ <%(k1)s> est initialisé a zéro"""),

    32 : _(u"""      Le champ <%(k1)s> est lu dans ETAT_INIT dans la structure de données résultats de nom <%(k2)s>"""),

    33 : _(u"""      Le champ <%(k1)s> est lu dans ETAT_INIT, par un champ donné explicitement"""),

    34 : _(u"""  Le champ de température initiale est calculé par un état stationnaire"""),

    35 : _(u"""  Le champ de température initiale est donné par une valeur qui vaut %(r1)19.12e"""),

    36 : _(u"""  Le champ <%(k1)s> est lu dans ETAT_INIT alors qu'il n'est pas nécessaire pour ce calcul. Il sera ignoré."""),

    50 : _(u"""
  Le champ <%(k1)s> est d'un type inconnu.
"""),

    51 : _(u"""  Le champ <%(k1)s> est de type <%(k2)s> mais on attend un champ de type <%(k3)s>.
On le convertit automatiquement"""),

    52 : _(u"""
  Le champ <%(k1)s> est de type <%(k2)s> mais on attend un champ de type <%(k3)s>.
  On ne sait pas le convertir automatiquement
"""),

}
