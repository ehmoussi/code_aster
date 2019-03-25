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

    3 : _("""
 type d'interface non supportée en cyclique
 type interface -->  %(k1)s
"""),

    4 : _("""
 arrêt sur type de résultat non supporté
 type donné      -->  %(k1)s
 types supportés -->  %(k2)s %(k3)s
"""),


    10 : _("""
 la maille %(k2)s n'existe pas dans le maillage %(k1)s
"""),

    11 : _("""
 le noeud %(k2)s n'existe pas dans le maillage %(k1)s
"""),

    13 : _("""
 arrêt sur base modale de type illicite
 base modale  -->  %(k1)s
 type         -->  %(k2)s
 type attendu -->  %(k3)s
"""),

    14 : _("""
 arrêt sur matrice de raideur non unique
"""),

    15 : _("""
 arrêt sur matrice de masse non unique
"""),

    16 : _("""
 arrêt sur matrice d'amortissement non unique en argument
"""),

    17 : _("""
 Le type de matrice %(k1)s est inconnu. Erreur développeur
"""),

    21 : _("""
 les matrices assemblées n'ont pas la même numérotation
 masse   = %(k1)s
 raideur = %(k2)s
"""),

    22 : _("""
 les matrices assemblées n'ont pas la même numérotation
 amortissement = %(k1)s
 raideur       = %(k2)s
"""),

    23 : _("""

 les matrices assemblées et la base modale n'ont pas le même maillage initial
 maillage matrice     : %(k1)s
 maillage base modale : %(k2)s
"""),

    24 : _("""
 arrêt sur problème de cohérence
 MODE_MECA donné       -->  %(k1)s
 numérotation associée -->  %(k2)s
 INTERF_DYNA donnée    -->  %(k3)s
 numérotation associée -->  %(k4)s
"""),

    25 : _("""
 sous-structure inexistante dans le modèle généralisé
 modèle généralisé : %(k1)s
 sous-structure    : %(k2)s
"""),

    26 : _("""
 problème de cohérence du nombre de champs de la base modale
 base modale                  : %(k1)s
 nombre de champs de la base  : %(i1)d
 nombre de degrés généralisés : %(i2)d
"""),

    27 : _("""
 le maillage %(k1)s n'est pas un maillage SQUELETTE
"""),

    28 : _("""
  aucun type d'interface défini pour la sous-structure :  %(i1)d
  pas de mode rigide d'interface
  le calcul de masses effectives risque d'être imprécis %(i2)d
"""),

    32 : _("""
   Il est aussi possible de renseigner une unique valeur pour NMAX_MODE
   (dans ce cas, cette valeur sera appliquée à chaque concept MODE_MECA).
"""),

    35 : _("""
 aucun champ n'est calculé dans la structure de données  %(k1)s
"""),

    61 : _("""
 le pas de temps du calcul métallurgique ne correspond pas
 au pas de temps du calcul thermique
 - numéro d'ordre              : %(i1)d
 - pas de temps thermique      : %(r1)f
 - pas de temps métallurgique  : %(r2)f
"""),



    63 : _("""
 données incompatibles :
 pour le MODE_STAT  :  %(k1)s
 il manque le champ :  %(k2)s
"""),


    66 : _("""
 Taille de bloc insuffisante
 taille de bloc demandée : %(r1)f
 taille de bloc utilisée : %(r2)f
"""),



    70 : _("""
 problème de cohérence du nombre de noeuds d'interface
 sous-structure1            : %(k1)s
 interface1                 : %(k2)s
 nombre de noeuds interface1: %(i1)d
 sous-structure2            : %(k3)s
 interface2                 : %(k4)s
 nombre de noeuds interface2: %(i2)d
"""),

    71 : _("""
 problème de cohérence des interfaces orientées
 sous-structure1           : %(k1)s
 interface1                : %(k2)s
 présence composante sur 1 : %(k3)s
 sous-structure2           : %(k4)s
 interface2                : %(k5)s
 composante inexistante sur 2 %(k6)s
"""),

    72 : _("""
 problème de cohérence des interfaces orientées
 sous-structure2           : %(k1)s
 interface2                : %(k2)s
 présence composante sur 2 : %(k3)s
 sous-structure1           : %(k4)s
 interface1                : %(k5)s
 composante inexistante sur 1 %(k6)s
"""),

    73 : _("""
 Sous-structures incompatibles
 sous-structure 1             : %(k1)s
 MACR_ELEM associé            : %(k2)s
 numéro grandeur sous-jacente : %(i1)d
 sous-structure 2             : %(k3)s
 MACR_ELEM associé            : %(k4)s
 numéro grandeur sous-jacente : %(i2)d
"""),

    74 : _("""
 arrêt sur incompatibilité de sous-structures
"""),

    75 : _("""
Erreur développement : code retour 1 dans en calculant la matrice tangente
Ce message est un message d'erreur développeur.
Contactez le support technique.
 """),

    77 : _("""
 les types des deux matrices sont différents
 type de la matrice de raideur :  %(k1)s
 type de la matrice de masse   :  %(k2)s
"""),

    78 : _("""
 les numérotations des deux matrices sont différentes
 numérotation matrice de raideur :  %(k1)s
 numérotation matrice de masse   :  %(k2)s
"""),

    79 : _("""
 coefficient de conditionnement des multiplicateurs de Lagrange :  %(r1)f
"""),

    80 : _("""
 affichage des coefficients d'amortissement :
 premier coefficient d'amortissement : %(r1)f
 second  coefficient d'amortissement : %(r2)f
"""),

    82 : _("""
 calcul du nombre de diamètres modaux demandé impossible
 nombre de diamètres demandé --> %(i1)d
"""),

    83 : _("""
 calcul des modes propres limité au nombre de diamètres maximum --> %(i1)d
"""),

    84 : _("""
 calcul cyclique :
 aucun nombre de diamètres nodaux licite
"""),

    85 : _("""
 liste de fréquences incompatible avec l'option
 nombre de fréquences --> %(i1)d
 option               --> %(k1)s
"""),

    87 : _("""
  résolution du problème généralisé complexe
  nombre de modes dynamiques:  %(i1)d
  nombre de ddl droite      :  %(i2)d
"""),

    88 : _("""
  nombre de ddl axe         :  %(i1)d
         dont cycliques     :  %(i2)d
         dont non cycliques :  %(i3)d
"""),

    89 : _("""
  dimension max du problème :  %(i1)d
"""),

    90 : _("""
La mise en oeuvre de la méthode de Mac Neal en sous structuration cyclique
n'est pas robuste dans le cas où des mouvements d'axe sont possibles
Conseil et solution : Utilisez la méthode de Craig & Bampton
"""),


    91 : _("""
 noeud sur l'AXE_Z
 noeud :  %(k1)s
"""),

    92 : _("""
La mise en oeuvre de la méthode de Mac Neal en sous structuration cyclique
conduit à un problème singulier pour le cas particulier où on a 2 ou 4 secteurs
Conseil et solution : Utilisez la méthode de Craig & Bampton
"""),

    94: _("""
 erreur de répétitivité cyclique
"""),

    95: _("""
 il manque un ddl sur un noeud  axe type du ddl -->  %(k1)s
 nom du noeud -->  %(k2)s
"""),

    99 : _("""
 arrêt sur nombres de noeuds interface non identiques
 nombre de noeuds interface droite:  %(i1)d
 nombre de noeuds interface gauche:  %(i2)d
"""),

}
