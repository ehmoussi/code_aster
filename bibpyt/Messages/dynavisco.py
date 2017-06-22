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

cata_msg={

1: _(u"""
Dans le cas TYPE_RESU='MODE',
la liste de fréquences donnée sous le mot-clé FREQ ou LIST_FREQ
doit contenir exactement 2 valeurs.
"""),

2: _(u"""
Dans le cas TYPE_RESU='HARM',
la liste de fréquences donnée sous le mot-clé FREQ ou LIST_FREQ
doit contenir au moins 2 valeurs.
"""),

3: _(u"""
Les modes propres finaux sont :
"""),

4: _(u"""
numéro    fréquence (HZ)
"""),

5: _(u""" %(i1)4d      %(r1)12.5E """),

6: _(u"""
numéro    fréquence (HZ)     amortissement
"""),

7: _(u""" %(i1)4d      %(r1)12.5E       %(r2)12.5E """),

8: _(u"""
Aucune excitation au second membre n'a été trouvée.
Pour le moment, l'opérateur DYNA_VISCO supporte uniquement
un second membre de type FORCE_NODALE.
"""),

}
