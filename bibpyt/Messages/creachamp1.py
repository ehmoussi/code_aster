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


   10 : _(u"""
   Les champs que l'on cherche à combiner doivent tous être des champs aux noeuds.
"""),

   11 : _(u"""
   Les champs que l'on cherche à combiner doivent tous avoir la même grandeur (DEPL_R, ...).
   Ce doit être la même que celle donnée dans TYPE_CHAM.
"""),

   12 : _(u"""
   Les champs que l'on cherche à combiner doivent tous avoir la même numérotation.
"""),

   13 : _(u"""
   Les champs que l'on cherche à combiner doivent tous s'appuyer sur le même maillage.
"""),

   14 : _(u"""
   On impose la même numérotation sur le champ de sortie (mots-clefs NUME_DDL ou CHAM_NO) que sur les champs d'entrée pour économiser de la mémoire.
   Mais cette opération fait perdre l'information sur les degrés de liberté correspondant aux conditions limites dualisées (AFFE_CHAR_MECA ou AFFE_CHAR_THER).
   Si vous ne voulez pas perdre cette information, il ne faut pas utiliser NUME_DDL ou CHAM_NO.
"""),


}
