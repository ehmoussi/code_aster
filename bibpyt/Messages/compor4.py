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

# person_in_charge: josselin.delmas at edf.fr

cata_msg = {

    1: _(u"""
Liste des comportements
"""),

    2: _(u"""
Comportement - Occurrence  %(i1)d"""),

    4: _(u"""Affecté sur %(i1)d éléments"""),

    5: _(u"""  Relation                             : %(k1)s"""),

    6: _(u"""  Déformation                          : %(k1)s"""),

    8: _(u"""  Algorithme contraintes planes (ou 1D): Deborst"""),

    9: _(u"""  Nombre total de variables internes   : %(i1)d"""),


    13: _(u"""
  Il y a deux types de modélisations différents pour une même affectation du comportement MFRONT.
  Chaque occurrence de COMPORTEMENT avec relation MFRONT doit contenir un seul type de modélisation.
  Par exemple, une occurrence pour les groupes de mailles contenant des éléments 3D (et comportement MFRONT),
  puis une occurrence pour les groupes de mailles contenant des éléments discrets (et comportement ELAS).

  Les types de modélisation rencontrés sont : %(k1)s et %(k2)s.
"""),


    14: _(u"""
  La modélisation %(k1)s dans le modèle n'est pas utilisable avec MFront.
  S'il s'agit d'éléments de type TUYAU ou PMF et que vous êtes en mode prototypage, vous devez activer ALGO_CPLAN='DEBORST' pour pouvoir l'utiliser.
"""),

    15: _(u"""
  Pour les comportements multiples (définis par DEFI_COMPOR), on n'a pas d'informations sur le nom des variables internes.
"""),

    16: _(u"""
  Il y a %(i1)d variables internes.
  Pour les comportements externes prototypes (MFRONT ou UMAT), on n'a pas d'informations sur le nom des variables internes.
"""),

    20: _(u"""         V%(i1)d : %(k1)s"""),

    21: _(u"""
Le comportement %(k1)s contient %(i1)d variables d'états externes (variables de commande):
"""),

    22: _(u"""         Variable externe %(i1)d : %(k1)s"""),

    23: _(u"""
Le comportement utilise la variable d'état externe %(k1)s (variables de commande).
Or elle n'a pas été définie dans AFFE_MATERIAU.
"""),

    24: _(u"""
Le comportement MFront utilise les phases du Zircaloy.
Ce n'est actuellement pas possible.
"""),

    25: _(u"""
La variable de commande %(k1)s a été définie dans AFFE_MATERIAU mais n'est pas définie dans le comportement MFront. 
"""),

    53: _(u"""
Comportement POLYCRISTAL
      Nombre de grains  %(i1)d : localisation %(k1)s
      Nombre d'occurrences de MONOCRISTAL différentes : %(i2)d - nombre de variables internes : %(i3)d
      Noms des variables internes: """),

    54: _(u""" A partir de la variable interne %(i1)d : pour chaque grain : """),

    55: _(u""" Dernière variable interne V%(i1)d : %(k1)s"""),

    56: _(u""" ... jusqu'à V%(i1)d """),


    62 : _(u"""
  -> Le critère de convergence pour intégrer le comportement 'RESI_INTE_RELA'
     est lâche (très supérieur à la valeur par défaut).
  -> Risque & Conseil :
     Cela peut nuire à la qualité de la solution et à la convergence.
"""),

    63 : _(u"""
La définition explicite du comportement est obligatoire.
"""),

    64 : _(u"""
Comme vous n'avez pas défini explicitement le comportement, tout le modèle est supposé élastique en petites perturbations.
"""),

    65 : _(u"""
Il y a trop d'occurrences du mot-clef facteur COMPORTEMENT. On n'affichera aucune information sur les comportements."""),

    70 : _(u"""
Le comportement s'intègre avec un algorithme de type analytique.
On ne peut donc pas utiliser le mot-clé  %(k1)s . On l'ignore.
"""),

    71 : _(u"""
La valeur propre numéro %(i1)d du module tangent local est négative et vaut %(r1)f.
L'énergie libre n'est donc pas convexe ce qui peut mener à des problèmes de convergence.
"""),

    72: _(u"""
L'occurrence %(i1)d du mot-clef COMPORTEMENT n'affecte aucune maille du modèle.
Par défaut, on affecte le comportement élastique en petites déformations sur les mailles du modèle non affectées par l'utilisateur
Conseils: vérifier que ce comportement est voulu (pas d'oubli dans AFFE_MODELE).
"""),

}
