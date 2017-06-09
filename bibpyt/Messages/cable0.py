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
    1: _(u"""
INST_FIN plus petit que INST_INIT.
"""),

    2: _(u"""
Le mot-clé MAILLE est interdit, utilisez GROUP_MA.
"""),

    3: _(u"""
Parmi les occurrences de CABLE_BP, le mot-clé ADHERENT renseigné dans DEFI_CABLE_BP
est 'OUI' pour certaines et 'NON' pour d'autres.
CALC_PRECONT ne peut pas traiter ce type de cas
"""),

    4: _(u"""
La liste d’instant fournie n’a pas permis d’identifier l’instant initial et 
l’instant final de la mise en précontrainte. 

Si vous avez renseigné l'opérande INST_INIT du mot-clé facteur INCREMENT, alors
cette valeur est prise en compte comme instant initial.
Si reuse est activé, l'instant initial est alors le dernier instant présent dans
l'objet résultat renseigné dans reuse.
Dans les autres cas, l'instant initial est le premier instant de la liste fournie.

Si vous avez renseigné l'opérande INST_FIN du mot-clé facteur INCREMENT, alors
cette valeur est prise en compte comme instant final. Sinon l'instant final
est la dernière valeur de la liste d'instants fournie.

"""),

}
