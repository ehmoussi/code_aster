# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

from ..Utilities import _

cata_msg = {

    1 : _("""
 Le mot-clé %(k2)s est absent, or il est obligatoire pour le contact de type %(k1)s.
"""),

    2 : _("""
 Le mot-clé %(k2)s n'est pas utilisé pour le contact de type %(k1)s.
 Il n'est donc pas pris en compte.
 """),

     3 : _("""
 Le mot-clé %(k1)s n'est pas utilisé pour le contact en présence du mot-clé SECTEUR.
 Il n'est donc pas pris en compte.
 """),

    4 : _("""
 Le calcul ne peut aboutir.

 Conseil :
 Vous devez augmenter la valeur de RAYON_MOBILE ou celle de LARGEUR_OBST.
"""),

    5 : _("""
 l'option  %(k1)s n'a pas été calculée pour la SD  %(k2)s
"""),

    6 : _("""
 le champ " %(k1)s " ( %(k2)s ) n'a pas été noté dans la SD  %(k3)s
"""),

    7 : _("""
 "TUBE_NEUF" n'a de sens que pour une table d'usure existante
"""),

    8 : _("""
 angle initial différent de -180. degrés.
"""),

    9 : _("""
 les angles ne sont pas croissants.
"""),

    10 : _("""
 angle final différent de 180. degrés.
"""),

    11 : _("""
 rayon mobile obligatoire avec secteur.
"""),

    12 : _("""
 rayon obstacle obligatoire avec secteur.
"""),

    13 : _("""
 la table usure en sortie est différente de celle en entrée
"""),

    14 : _("""
 le nombre de secteurs en sortie est différent de celui en entrée
"""),

    15 : _("""
 problème extraction pour la table  %(k1)s
"""),

    17 : _("""
 aucune valeur de moment présente
"""),

    18 : _("""
 y a un bogue: récupération des fréquences
"""),

    19 : _("""
 il faut au moins un GROUP_MA_RADIER
"""),

    20 : _("""
 rigidité de translation non nulle
"""),

    21 : _("""
 rigidité de rotation non nulle
"""),

    22 : _("""
Le nombre de composantes des "raideurs" et le nombre de composantes du MODE_MECA porté par les noeuds du
GROUP_MA_RADIER sont différents :
 - Vous avez donné pour les raideurs KX, KY, KZ, KRX, KRY, KRZ.
 - Sur un des noeuds du GROUP_MA_RADIER, le MODE_MECA n'a pas les composantes DRX, DRY, DRZ.
On ne peut donc pas tenir compte des KRX, KRY, KRZ. Les degrés de libertés sont incompatibles.
"""),

    23 : _("""
 nombres de GROUP_MA et AMOR_INTERNE différents
"""),

    24 : _("""
 nombres de composantes amortissements et mode différents
"""),

    26 : _("""
 le type du concept résultat  n'est ni EVOL_ELAS, ni EVOL_NOLI.
"""),

    27 : _("""
 vous avez probablement archive l état initial dans la commande STAT_NON_LINE. cela correspond au numéro d ordre 0. nous ne tenons pas compte du résultat a ce numéro d ordre pour le calcul de de la fatigue.
"""),

    29 : _("""
 les champs de  contraintes aux points de gauss n'existent pas.
"""),

    30 : _("""
 le champ simple qui contient les valeurs des contraintes n existe pas.
"""),









    34 : _("""
 les champs de déformations aux points de gauss n'existent pas.
"""),

    35 : _("""
 le champ simple qui contient les valeurs des déformations n existe pas.
"""),






    37 : _("""
 le champ simple qui contient les valeurs des déformations plastiques n'existe pas.
"""),

    38 : _("""
 le champ de contraintes aux noeuds SIEF_NOEU ou SIEF_NOEU n'a pas été calculé.
"""),





    40 : _("""
 le champ de contraintes aux noeuds n'existe pas.
"""),

    41 : _("""
 le champ de déformations aux noeuds n'existe pas.
"""),





    43 : _("""
 le champ de déformations plastiques aux noeuds n'existe pas.
"""),

    45 : _("""
 Pour calculer la déformation élastique, la déformation totale est obligatoire.
"""),

    46: _("""
 On note que déformation élastique  = déformation TOTALE - déformation PLASTIQUE. Si la déformation
 plastique n'est pas calculée dans le résultat, on prendre la valeur zéro.
"""),

    47 : _("""
 INST_INI plus grand que INST_FIN
"""),

    48 : _("""
 Instant initial du cycle ne se trouve pas dans la liste des instants calculés. On prend l'instant initial stocké
 comme instant initial pour la partie du chargement cyclique.
 Risques et conseils: On peut modifier la liste des instants fournie dans STAT_NON_LINE en utilisant une liste d'instant manuelle
 pour assurer que l'instant initial du cycle fait partie des instants calculés.
"""),


    57 : _("""
  erreur données.
"""),

    58 : _("""
 présence de point(s) que dans un secteur.
"""),

    59 : _("""
 aucun cercle n'est circonscrit aux quatre points.
"""),


    76 : _("""
 le champ demandé n'est pas prévu
"""),

    77 : _("""
 NOM_CHAM:  %(k1)s  interdit.
"""),

    82 : _("""
 type  %(k1)s  non implante.
"""),

    83 : _("""
 profondeur > rayon du tube
"""),

    84 : _("""
 pas d'informations dans le "RESU_GENE" sur l'option "choc".
"""),

    85 : _("""
 modèle non valide.
"""),

    86 : _("""
  seuil / v0  > 1
"""),

    87 : _("""
  ***** arrêt du calcul *****
"""),

    89 : _("""
 type non traite  %(k1)s
"""),

    90 : _("""
 les tables TABL_MECA_REV et TABL_MECA_MDB n'ont pas les mêmes dimensions
"""),

    91 : _("""
 les tables n'ont pas les mêmes instants de calculs
"""),

    92 : _("""
 les tables n'ont pas les mêmes dimensions
"""),




    94 : _("""
Élément inconnu.
   Type d'élément GIBI          : %(i1)d
   Nombre de sous objet         : %(i2)d
   Nombre de sous référence     : %(i3)d
   Nombre de noeuds par élément : %(i4)d
   Nombre d'éléments            : %(i5)d

La ligne lue dans le fichier doit ressembler à ceci :
%(i1)8d%(i2)8d%(i3)8d%(i4)8d%(i5)8d
"""),

    95 : _("""
On a lu un objet dit composé (car type d'élément = 0) qui serait
composé de 0 sous objet !
"""),




    97 : _("""
 La maille de peau : %(k1)s ne peut pas être réorientée.
 Car elle est insérée entre 2 mailles "support" placées de part et d'autre : %(k2)s et %(k3)s.

Conseils :
 Vous pouvez utiliser les mots-clés GROUP_MA_VOL en 3D et GROUP_MA_SURF en 2D pour choisir une des
 deux mailles supports et ainsi choisir la normale permettant la réorientation.
"""),

}
