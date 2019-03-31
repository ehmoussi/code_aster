# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

cata_msg = {

    1 : _("""
 contraintes planes en grandes déformations non implantées
"""),

    2 : _("""
 caractéristique fluage incomplet
"""),

    20 : _("""
 La définition du repère d'orthotropie a été mal faite.
 Utilisez soit ANGL_REP  soit ANGL_AXE de la commande AFFE_CARA_ELEM mot clé facteur MASSIF
"""),

    22 : _("""
 type d'élément incompatible avec une loi élastique anisotrope
"""),

    24 : _("""
 Le chargement de type cisaillement (mot-clé CISA_2D) ne peut pas être suiveur (mot-clé TYPE_CHAR='SUIV').
"""),

    25 : _("""
 On ne sait pas traiter un chargement de type pression (mot-clé PRES_REP) suiveuse (mot-clé TYPE_CHAR_='SUIV') imposé sur l'axe du modèle axisymétrique.

 Conseils :
  - Vérifiez que le chargement doit bien être suiveur.
  - Vérifiez que la zone d'application du chargement est la bonne.
"""),

    28 : _("""
 prédiction par extrapolation impossible : pas de temps nul
"""),

    31 : _("""
La borne supérieure est incorrecte.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    32 : _("""
 la viscosité N doit être différente de zéro
"""),

    33 : _("""
 la viscosité UN_SUR_K doit être différente de zéro
"""),

    65 : _("""
Arrêt suite à l'échec de l'intégration de la loi de comportement.
   Vérifiez vos paramètres, la cohérence des unités.
   Essayez d'augmenter ITER_INTE_MAXI.
"""),

    66 : _("""
  convergence atteinte sur approximation linéaire tangente de l'évolution plastique
  risque d'imprécision
"""),

    67 : _("""
  endommagement maximal atteint au cours des résolutions internes
"""),

    87 : _("""
 l'incrément de temps vaut zéro, vérifiez votre découpage
"""),

    88 : _("""
 fluence décroissante (flux<0)
"""),

    89 : _("""
 le paramètre A doit être >=0
"""),

    91 : _("""
 stop, RIGI_MECA_TANG non disponible
"""),

    92 : _("""
 la maille doit être de type SEG3, TRIA6, QUAD8 TETRA10, PENTA15 ou HEXA20.
 or la maille est de type :  %(k1)s .
"""),


}
