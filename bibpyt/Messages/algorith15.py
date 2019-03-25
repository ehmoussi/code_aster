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
 arrêt sur nombres de DDL interface non identiques
 nombre de ddl interface droite:  %(i1)d
 nombre de ddl interface gauche:  %(i2)d
"""),

    2 : _("""
La dimension de la matrice de changement de base est incorrecte ;

- dimension effective   :  %(i1)d
- dimension en argument :  %(i2)d
"""),

    3 : _("""
  erreur de répétitivité cyclique
"""),

    4 : _("""
  il manque un DDL sur un noeud gauche
  type du DDL  -->  %(k1)s
  nom du noeud -->  %(k2)s
"""),

    5 : _("""
  un ddl interdit a été activé dans l'interface de répétitivité cyclique
  type du DDL  -->  %(k1)s
  nom du noeud -->  %(k2)s
"""),

    6 : _("""
  il manque un DDL sur un noeud droite
  type du ddl  -->  %(k1)s
  nom du noeud -->  %(k2)s
"""),

    7 : _("""
 arrêt sur problème de répétitivité cyclique
"""),

    8 : _("""
 la composante : %(k1)s  est une composante indéfinie
"""),

    9 : _("""
  arrêt pour cause de ddls interdits :
  seules les composantes DX, DY, DZ, DRX, DRY, DRZ sont autorisées
"""),

    10 : _("""
 arrêt sur type de DDL non défini
"""),

    11 : _("""
Le nombre de points est inférieur au nombre de points de l'interspectre.
 le spectre est tronqué à la fréquence :  %(r1)f
"""),

    12 : _("""
Le nombre de points donné est modifié
 (en une puissance de 2 compatible avec l'interspectre)
Le nombre de points retenu est :   %(i1)d
"""),

    13 : _("""
La durée est trop grande ou le nombre de points est trop petit par rapport
 à la fréquence max (théorème de Shannon).
 on choisit   %(i1)d points
"""),

    14 : _("""
 la durée est petite par rapport au pas de discrétisation de l'interspectre.
 choisir plutôt : durée >  %(r1)f
"""),

    15 : _("""
Le nombre de points est petit par rapport au pas de discrétisation de l'interspectre.
On a %(i1)d. Il faudrait un nombre supérieur à :  %(r1)f
"""),

    16 : _("""
 on n'a pas trouve le DDL pour le noeud :  %(k1)s
"""),

    17 : _("""
    de la sous-structure :  %(k1)s
"""),

    18 : _("""
    et sa composante :  %(k1)s
"""),




    24 : _("""
 au moins un terme de ALPHA est négatif à l'abscisse :  %(i1)d
"""),

    25 : _("""
 ALPHA est nul et le nombre de mesures est strictement inférieur au nombre de modes
 risque de matrice singulière
"""),

    26 : _("""
 calcul moindre norme
"""),

    27 : _("""
  problème calcul valeurs singulières
  pas      =   %(i1)d
  abscisse =    %(r1)f
"""),

    28 : _("""
  la matrice (PHI)T*PHI + ALPHA n'est pas inversible
  pas      =   %(i1)d
  abscisse =    %(r1)f
"""),






















    45 : _("""
  on ne trouve pas
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    46 : _("""
  nombre d'itérations insuffisant
"""),

    47 : _("""
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    48 : _("""
  maille :  %(k1)s
  nombre d itérations =  %(i1)d
  ITER_INTE_MAXI =  %(i2)d
"""),

    49 : _("""
  DP    actuel =  %(r1)f
  F(DP) actuel =  %(r2)f
"""),

    50 : _("""
  DP    initial   =  %(r1)f
  F(DP) initial   =  %(r2)f
"""),

    51 : _("""
  DP    maximum   =  %(r1)f
  F(DP) maximum   =  %(r2)f
"""),

    52 : _("""
  allure de la fonction
  nombre points :  %(i1)d
"""),

    53 : _("""
  DP     =  %(r1)f
  F(DP)  =  %(r2)f
"""),




    55 : _("""
  incohérence détectée
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    56 : _("""
  le noeud :  %(k1)s  de l'interface dynamique :  %(k2)s
  n'appartient pas la sous-structure:  %(k3)s
"""),





    58 : _("""
  le noeud :  %(k1)s  de l interface dynamique :  %(k2)s
  n'est pas correctement référencé dans le squelette :  %(k3)s
"""),

    59: _("""
  Le nombre de secteur doit être supérieur ou égal à 2 (mot clé NB_SECTEUR)
"""),

    60 : _("""
  le noeud :  %(k1)s  de l'interface dynamique :  %(k2)s
  n'appartient pas la sous-structure:  %(k3)s
"""),




    62 : _("""
  le noeud :  %(k1)s  de l'interface dynamique :  %(k2)s
  n'est pas correctement référencé dans le squelette :  %(k3)s
"""),

    63 : _("""
  conflit mot clés TOUT et GROUP_NO dans RECO_GLOBAL
"""),

    64 : _("""
  erreur de nom
  la sous-structure :  %(k1)s  n a pas été trouvée
"""),

    65 : _("""
  incohérence de nom
  l interface dynamique  :  %(k1)s
  de la sous-structure   :  %(k2)s
  a pour groupe de noeud :  %(k3)s
  or GROUP_NO_1 =  %(k4)s
"""),

    66 : _("""
  erreur de nom
  la sous-structure :  %(k1)s  n'a pas été trouvée
"""),

    67 : _("""
  incohérence de nom
  l interface dynamique  :  %(k1)s
  de la sous-structure   :  %(k2)s
  a pour groupe de noeud :  %(k3)s
  or GROUP_NO_2 =  %(k4)s
"""),


    69 : _("""
 nombre incorrect de sous-structures
 il vaut :  %(i1)d
 alors que le nombre total de sous-structures vaut :  %(i2)d
"""),

    70 : _("""
 nombre incorrect de sous-structures
 pour le chargement numéro : %(i1)d
 il en faut exactement :  %(i2)d
 vous en avez          :  %(i3)d
"""),

    71 : _("""
 nombre incorrect de vecteurs chargements
 pour le chargement numéro : %(i1)d
 il en faut exactement :  %(i2)d
 vous en avez          :  %(i3)d
"""),

    72 : _("""
Il manque la numérotation pour le chargement : %(k1)s
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    73 : _("""
 on doit avoir le même type de forces pour un même chargement global
 or, la grandeur vaut   :  %(i1)d
 pour la sous-structure    %(k1)s
 et elle vaut           :  %(i2)d
 pour la sous-structure    %(k2)s
"""),

    74 : _("""
 une des bases modales a un type incorrect
 elle est associée à la sous-structure  %(k1)s
"""),

    75 : _("""
 les numérotations ne coïncident pas pour la sous-structure : %(k1)s
 la numérotation pour la base modale est :  %(k2)s
 et celui pour le second membre       :  %(k3)s
"""),

    85 : _("""
  L'interface de droite %(k1)s n'existe pas
  Conseil: vérifiez si vous avez défini cette interface dans le modèle
"""),

    86 : _("""
  l'interface de gauche %(k1)s n'existe pas
  Conseil: vérifiez si vous avez défini cette interface dans le modèle
"""),

    87 : _("""
  l'interface axe %(k1)s n'existe pas
  Conseil: vérifiez si vous avez défini cette interface dans le modèle
"""),

    88 : _("""
 arrêt sur problème interfaces de type différents
"""),

    89 : _("""
 arrêt sur problème de type interface non supporté
 type interface -->  %(k1)s
"""),

    90 : _("""
 le nombre d'amortissements réduits est trop grand
 le nombre de modes propres vaut  %(i1)d
 et le nombre de coefficients  :  %(i2)d
 on ne garde donc que les  %(i3)d premiers coefficients
"""),

    91 : _("""
 le nombre d'amortissements réduits est insuffisant
 il en manque :  %(i1)d
 car le nombre de modes vaut :  %(i2)d
 on rajoute %(i3)d coefficients avec la valeur du dernier coefficient.
"""),

    92 : _("""
 MODE_MECA : %(k1)s
 Nombre de modes propres calculés insuffisant
 par rapport au nombre demandé sous NMAX_MODE (%(i1)d).
 Nombre de modes propres limité à : %(i2)d.
"""),





    98 : _("""
 incohérence dans le DATASET 58
 le nombre de valeurs fournies ne correspond pas au nombre de valeurs attendues
 mesure concernée :  %(i1)d

"""),

}
