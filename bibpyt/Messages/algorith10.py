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

# person_in_charge: josselin.delmas at edf.fr

cata_msg = {

    1 : _("""
 la variable  %(k1)s  n'existe pas dans la loi  %(k2)s
"""),


    11 : _("""
 le champ de déplacement n'a pas été calculé
"""),

    12 : _("""
 le champ de vitesse n'a pas été calculé
"""),

    13 : _("""
 le champ d'accélération n'a pas été calcule.
"""),

    14 : _("""
 développement non prévu pour le MULT_APPUI ou CORR_STAT.
"""),

    15 : _("""
 développement non prévu pour la sous-structuration.
"""),

    16 : _("""
 dans le cas harmonique les seuls champs restituables sont
 'DEPL', 'VITE' et 'ACCE'.
"""),

    17 : _("""
 l'option  %(k1)s  s'applique sur toute la structure
"""),

    20 : _("""
  le comportement :  %(k1)s  n'a pas été défini
"""),

    21 : _("""
 DIST_REFE est obligatoire à la première occurrence de RECO_GLOBAL
"""),

    31 : _("""
 la bande de fréquence retenue ne comporte pas de modes propres
"""),

    32 : _("""
 vous avez demandé des modes qui ne sont pas calculés
"""),

    33 : _("""
 il n y a pas de mode statique calculé pour le couple (noeud, composante) ci dessus
"""),

    35 : _("""
 redécoupage excessif du pas de temps interne
 réduisez votre pas de temps ou augmenter ABS(ITER_INTE_PAS)
 redécoupage global.
"""),


    41 : _("""
 incohérence de A ou H
"""),

    42 : _("""
 incohérence de données
"""),

    43 : _("""
 incohérence de C, PHI ou A
"""),

    44 : _("""
 champ 'DEPL' non calculé
"""),

    45 : _("""
 champ 'VITE' non calculé
"""),

    46 : _("""
 champ 'ACCE' non calculé
"""),

    47 : _("""
 lecture des instants erronée
"""),

    48 : _("""
 axe de rotation indéfini.
"""),

    49 : _("""
 la porosité initiale F0 ne peut être nulle ou négative
"""),

    50 : _("""
 la porosité initiale F0 ne peut être supérieure ou égale à 1.
"""),

    52 : _("""
 la porosité initiale F0 ne peut être négative
"""),

    56 : _("""
 on ne sait pas post-traiter le champ de type:  %(k1)s
"""),

    61 : _("""
 il faut définir une BANDE ou un NUME_ORDRE
"""),

    62 : _("""
 il faut définir une "BANDE" ou une liste de "NUME_ORDRE"
"""),

    63 : _("""
 dimension spectrale fausse
"""),

    64 : _("""
 l'interspectre modal est de type "ACCE"
 on ne peut que restituer une accélération
"""),

    65 : _("""
 l'interspectre modal est de type "VITE"
 on ne peut que restituer une vitesse
"""),

    66 : _("""
 l'interspectre modal est de type "DEPL"
 on ne peut pas restituer une accélération
"""),

    67 : _("""
 l'interspectre modal est de type "DEPL"
 on ne peut pas restituer une vitesse
"""),

    68 : _("""
 Il faut spécifier autant de noeuds (par GROUP_NO ou NOEUD) que de composants (NOM_CMP)
"""),

    69 : _("""
 il faut autant de "MAILLE" que de "NOEUD"
"""),

    72 : _("""
 il faut définir une liste de mailles pour post-traiter un CHAM_ELEM
"""),

    73 : _("""
 la composante  %(k1)s  du noeud  %(k2)s  pour la maille  %(k3)s  n'existe pas.
"""),

    76 : _("""
 mot-clé NB_BLOC inopérant on prend un bloc
"""),

    87 : _("""
 vecteur de norme trop petite
"""),

    88 : _("""
 le seul comportement élastique valide est ELAS
 """),

    91 : _("""
 Loi de séchage %(k1)s : le coefficient de diffusion atteint des valeurs trop élevées %(r1)f. Il se peut que cela soit dû à la stabilité du thêta-schéma qui empêche la convergence du calcul non linéaire. 
 Conseils :
 - Branchez REAC_ITER >=1 (actualisation fréquente de la matrice tangente);
 - Changez la valeur de PARM_THETA dans THER_NON_LINE tout en raffinant le pas de temps. 
"""),


    93 : _("""
 il faut un nom de champ
"""),

    95 : _("""
 pour interpoler il faut fournir une liste de fréquences ou instants.
"""),

    98 : _("""
 pivot nul
"""),

    99 : _("""
 on ne sait pas encore traiter la sous structuration en axisymétrique
"""),

}
