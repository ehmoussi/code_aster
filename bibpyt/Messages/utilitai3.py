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

# person_in_charge: josselin.delmas at edf.fr

cata_msg = {

    2 : _("""
 l'utilisation de cette commande n'est légitime que si
 la configuration étudiée est du type "FAISCEAU_TRANS"
"""),

    4 : _("""
 le nom d'un paramètre ne peut pas dépasser 16 caractères
"""),

    5 : _("""
 le paramètre  %(k1)s  n'existe pas
"""),

    6 : _("""
 seuls les paramètres de types réel, entier ou complexe sont traites
"""),

    7 : _("""
 erreur DPVP_2
"""),

    8 : _("""
 code retour non nul détecté
"""),

    9 : _("""
 maillage autre que SEG2 ou POI1
"""),

    10 : _("""
 mailles ponctuelles plexus POI1 ignorées
"""),

    11 : _("""
 le format doit être IDEAS
"""),

    12 : _("""
 le maillage doit être issu d'IDEAS
"""),

    13 : _("""
  maillage non issu d'IDEAS
"""),

    14 : _("""
 avec le 2414, on ne traite pas les NUME_ORDRE
"""),

    15 : _("""
 Problème lecture du fichier IDEAS
"""),

    17 : _("""
 format  %(k1)s  inconnu.
"""),

    18 : _("""
C'est curieux :  %(k1)s
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    19 : _("""
 problème maillage <-> modèle
"""),

    21 : _("""
 maillage et modèle incohérents.
"""),

    22 : _("""
Il faut renseigner le mot clé modèle.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    23 : _("""
Erreur :
  Aucun élément fini du LIGREL %(k1)s ne sait calculer le
  paramètre: %(k2)s de l'option:  %(k3)s.
  Le champ par éléments que l'on veut créer est vide. On ne peut pas continuer.
"""),

    24 : _("""
L'option %(k1)s  est incompatible avec TYPE_CHAM %(k2)s
"""),

    25 : _("""
L'opération %(k1)s est possible seulement TYPE_CHAM 'NOEU_GEOM_R'
"""),

    26 : _("""
L'opération  %(k1)s est incompatible avec TYPE_CHAM %(k2)s
"""),

    27 : _("""
 grandeurs différentes pour : %(k1)s et : %(k2)s
"""),

    28 : _("""
 il existe des doublons dans la liste d'instants de rupture
"""),

    29 : _("""
 il faut donner plus d'un instant de rupture
"""),

    30 : _("""
 il manque des températures  associées aux bases de résultats (mot-clé tempe)
"""),

    31 : _("""
 le paramètre m de WEIBULL doit être le même pour toutes les bases résultats !
"""),

    32 : _("""
 le paramètre SIGM_REFE de WEIBULL doit être le même pour toutes les bases résultats !
"""),

    33 : _("""
 aucun numéro d'unité logique n'est associe a  %(k1)s
"""),

    34 : _("""
 aucun numéro d'unité logique n'est disponible
"""),

    35 : _("""
 action inconnue:  %(k1)s
"""),

    36 : _("""
 Arrêt de la procédure de recalage : le paramètre m est devenu trop petit (m<1),
 vérifiez vos listes d'instants de rupture
"""),

    37 : _("""
 les paramètres de la nappe ont été réordonnées.
"""),

    38 : _("""
 type de fonction non connu
"""),

    39 : _("""
 points confondus.
"""),

    43 : _("""
 le mot-clé "reuse" n'existe que pour l'opération "ASSE"
"""),

    46 : _("""
 le groupe de mailles " %(k1)s " n'existe pas.
"""),

    47 : _("""
 le groupe  %(k1)s  ne contient aucune maille.
"""),

    48 : _("""
 on ne traite que des problèmes 2d.
"""),

    49 : _("""
 la maille " %(k1)s " n'existe pas.
"""),

    50 : _("""
 On doit donner un résultat de type "EVOL_THER" après le mot-clé "LAPL_PHI"
 du mot-clé facteur "CARA_POUTRE" dans la commande POST_ELEM pour calculer
 la constante de torsion.
"""),

    51 : _("""
 Le nombre d'ordres du résultat  %(k1)s  nécessaire pour calculer la constante
 de torsion doit être égal a 1.
"""),

    53 : _("""
 La table "CARA_GEOM" n'existe pas.
"""),

    54 : _("""
 On doit donner un résultat de type "EVOL_THER" après le mot-clé "LAPL_PHI_Y"
 du mot-clé facteur "CARA_POUTRE" dans la commande POST_ELEM pour calculer les
 coefficients de cisaillement et les coordonnées du centre de torsion.
"""),

    55 : _("""
 On doit donner un résultat de type "EVOL_THER" après le mot-clé "LAPL_PHI_Z"
 du mot-clé facteur "CARA_POUTRE" dans la commande POST_ELEM pour calculer les
 coefficients de cisaillement et les coordonnées du centre de torsion.
"""),

    56 : _("""
 Le nombre d'ordres du résultat  %(k1)s  nécessaire pour calculer les coefficients
 de cisaillement et les coordonnées du centre de torsion doit être égal a 1.
"""),

    57 : _("""
 On doit donner un résultat de type "EVOL_THER" après le mot-clé "LAPL_PHI"
 du mot-clé facteur "CARA_POUTRE" dans la commande POST_ELEM pour calculer la
 constante de gauchissement.
"""),

    58 : _("""
 Le nombre d'ordres du résultat  %(k1)s  nécessaire pour calculer la constante de
 gauchissement doit être égal a 1.
"""),

    59 : _("""
 Il faut donner le nom d'une table issue d'un premier calcul avec l'option "CARA_GEOM"
 de  POST_ELEM après le mot-clé "CARA_GEOM" du mot-clé facteur "CARA_POUTRE".
"""),

    60 : _("""
 Il faut obligatoirement définir l'option de calcul des caractéristiques de poutre
 après le mot-clé "option" du mot-clé facteur "CARA_POUTRE" de la commande POST_ELEM.
"""),

    61 : _("""
 l'option  %(k1)s n'est pas admise après le mot-clé facteur "CARA_POUTRE".
"""),

    62 : _("""
 il faut donner le nom d'un résultat de type EVOL_THER
 après le mot-clé LAPL_PHI du mot-clé facteur "CARA_POUTRE".
"""),

    63 : _("""
 il faut donner le nom d'un résultat de type EVOL_THER
 après le mot-clé LAPL_PHI_Y du mot-clé facteur "CARA_POUTRE".
"""),

    64 : _("""
 il faut donner le nom d'un résultat de type EVOL_THER
 après le mot-clé LAPL_PHI_Z du mot-clé facteur "CARA_POUTRE".
"""),

    69 : _("""
 champ de vitesse donné
"""),

    70 : _("""
 champ de déplacement donné
"""),

    71 : _("""
 option masse cohérente.
"""),

    72 : _("""
 calcul avec masse diagonale
"""),

    73 : _("""
 type de champ inconnu.
"""),

    76 : _("""
 Pour calculer les indicateurs globaux d'énergie, il faut donner un résultat
 issu de STAT_NON_LINE .
"""),

    77 : _("""
 on attend un résultat de type "EVOL_NOLI" ou "EVOL_ELAS".
"""),

    79 : _("""
 Le résultat  %(k1)s  doit comporter un champ de variables internes au numéro
 d'ordre  %(k2)s  .
"""),

    80 : _("""
 Impossibilité : le volume du modèle traite est nul.
"""),

    81 : _("""
 impossibilité : le volume du GROUP_MA  %(k1)s  est nul.
"""),

    82 : _("""
 impossibilité : le volume de la maille  %(k1)s  est nul.
"""),

    83 : _("""
 Erreur: les options de calcul doivent être identiques pour toutes les occurrences
 du mot clef facteur
"""),

    84 : _("""
 on attend un concept "EVOL_NOLI"
"""),

    89 : _("""
 les 2 nuages : %(k1)s  et  %(k2)s  doivent avoir le même nombre de coordonnées.
"""),

    90 : _("""
 les 2 nuages : %(k1)s  et  %(k2)s  doivent avoir la même grandeur associée.
"""),

    91 : _("""
 il manque des composantes sur :  %(k1)s
"""),

    93 : _("""
 seuls les types "réel" et "complexe" sont autorises.
"""),

}
