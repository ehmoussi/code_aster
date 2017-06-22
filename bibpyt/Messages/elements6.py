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

    2 : _(u"""
On ne sait pas calculer les déformations plastiques avec de l'élasticité non-isotrope.
"""),

   3 : _(u"""
  -> Attention vous êtes en contraintes planes, et vous utilisez la loi
     de comportement %(k1)s. La composante du tenseur des déformations
     plastiques EPZZ est calculée en supposant l'incompressibilité des
     déformations plastiques : EPZZ = -(EPXX + EPYY).
  -> Risque & Conseil :
     Vérifiez que cette expression est valide avec votre loi de comportement.
"""),

    5 : _(u"""
On ne peut pas utiliser le modèle 3D_SI avec un comportement élastique de type %(k1)s.
"""),

    6 : _(u"""
  -> Erreur de programmation :
  -> L argument %(k1)s est manquant ou mal renseigné dans une routine élémentaire XFEM
  -> Veuillez renseigner cette argument
"""),

    9 : _(u"""
  -> Erreur de programmation :
  -> En dimension %(i1)d, le calcul d'une matrice de passage n'a pas de sens.
"""),

    10 : _(u"""
  -> Erreur de programmation :
  -> Au moins un des paramètres élastiques (module d'Young ou coefficient de poisson) n'a
     pas été trouvé lors de l'évaluation des fonctions vectorielles XFEM
"""),

}
