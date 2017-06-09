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
 Cas fluides multiples : précisez le GROUP_MA dans lequel vous affectez la masse volumique RHO.
"""),

    2: _(u"""
 PRES_FLUIDE obligatoire une fois.
"""),

    3: _(u"""
 Amortissement ajouté sur modèle généralisé non encore implanté.
"""),

    4: _(u"""
 Rigidité ajouté sur modèle généralisé non encore implanté.
"""),

    5: _(u"""
 La construction d'un nouveau concept NUME_DDL ne peut se faire qu'en présence du mot clé MATR_ASSE avec une des options
 suivantes: RIGI_MECA, RIGI_THER, RIGI_ACOU ou RIGI_FLUI_STRU.
 Attention: si vous cherchez à assembler des vecteurs seulement, le concept NUME_DDL doit être construit préalablement.
"""),

    6: _(u"""
  Attention: le mot-clé CHARGE définissant les conditions de Dirichlet n'a pas été renseigné.
  Pour l'assemblage d'un vecteur selon une numérotation imposée (NUME_DDL), le mot-clé CHARGE
  doit être renseigné à l'identique que lors de la création du NUME_DDL, sous risque d'assemblage erroné.
  Cependant, si votre modèle ne contient aucune condition de Dirichlet votre syntaxe est correcte.
"""),

    7: _(u"""
  Le mot-clé CHAM_MATER est obligatoire pour la construction d'un vecteur assemblé avec l'option CHAR_ACOU.
"""),

    8: _(u"""
  Pour la construction d'un vecteur assemblé il faut renseigner au moins une charge.
"""),

    9: _(u"""
 Une des options doit être RIGI_MECA ou RIGI_THER ou RIGI_ACOU ou RIGI_FLUI_STRU.
"""),

    10: _(u"""
 Pour calculer RIGI_MECA_HYST, il faut avoir calculé RIGI_MECA auparavant (dans le même appel).
"""),

    11: _(u"""
 Pour calculer AMOR_MECA, il faut avoir calculé RIGI_MECA et MASS_MECA auparavant (dans le même appel).
"""),

    12: _(u"""
 Une des charges renseignées pour l'assemblage des vecteurs est déjà présente dans le mot-clé
 CHARGE définissant les conditions de Dirichlet. Il est interdit de renseigner plus d'une fois la même charge.
"""),

    13: _(u"""
La numérotation généralisée retenue pour la construction des
matrices ne fait pas référence au modèle généralisé. Si vous essayez de
construire une matrice généralisée à partir d'une matrice assemblée et
d'une base, il faut utiliser la commande PROJ_BASE.
"""),


}
