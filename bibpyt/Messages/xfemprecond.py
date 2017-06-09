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

# person_in_charge: patrick.massin at edf.fr


cata_msg = {

    1: _(u"""
  Alarme émise par le pré-conditionneur XFEM:
  La structure de la matrice n'est reconnue par le pré-conditionneur
  XFEM.
  Par précaution, on ne modifie pas le problème de départ.
  La résolution se poursuit sans pré-conditionneur XFEM.
"""),

    3 : _(u"""
  Erreur calcul matriciel:
  La matrice %(i1)d est pré-conditionnée sur les noeuds
  XFEM.
  Vous pourriez obtenir des résultats inattendus.
"""),

    4 : _(u"""
  Erreur lors d'un produit matrice-vecteur:
  La matrice %(i1)d est pré-conditionnée sur les noeuds
  XFEM.
  Vous pourriez obtenir des résultats inattendus.
"""),

    6 : _(u"""
  La mise à l'échelle des ddls X-FEM sera activée pour la suite de la résolution.
"""),

    7 : _(u"""
  Le pré-conditionneur XFEM a détecté une ligne pratiquement nulle à l'équation %(i1)d
  correspondante au noeud N%(i2)d et au degré de liberté %(k1)s.
  Conseils:
    - S'il s'agit d'un degré de liberté de type contact : vérifier que le chargement contact est 
      bien appliqué à la résolution et que toutes les sous-facettes de contact sont présentes en
      activant MODI_MODELE_XFEM/DECOUPE_FACETTE='SOUS_ELEMENTS'
    - Sinon, désactiver le pré-conditionneur X-FEM dans le MODI_MODELE_XFEM/PRETRAITEMENTS='SANS'
      pour tenter de poursuivre le calcul. Cette opération est très risquée.
"""),

    8 : _(u"""
  -> La connectivité stockée lors de la découpe XFEM ne situe pas 
     dans les bornes autorisées.
     Cela risque de produire des sous-éléments distordus à cause de la 
     mauvaise localisation des points de découpe.
  """),

}
