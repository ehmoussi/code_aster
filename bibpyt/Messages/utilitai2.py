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

    4 : _(u"""
 Il y a un problème pour récupérer les variables d'accès.
"""),

    5 : _(u"""
 Seules les variables d'accès réelles sont traitées.
"""),

    6 : _(u"""
 Seuls les paramètres réels sont traités.
"""),

    7 : _(u"""
 L'unité logique est inexistante.
"""),

    8 : _(u"""
  Les fonctions à une seule variable sont admises.
"""),

    10 : _(u"""
  Les fonctions de type " %(k1)s " ne sont pas encore imprimées.
"""),

    11 : _(u"""
  Les fonctions de type " %(k1)s " ne sont pas imprimées.
"""),

    12 : _(u"""
 interpolation sur paramètres non permise
"""),

    13 : _(u"""
 interpolation " %(k1)s " inconnue
"""),

    14 : _(u"""
 " %(k1)s " type de fonction inconnu
"""),

    16 : _(u"""
 interpolation non permise
"""),

    17 : _(u"""
 on ne connaît pas ce type d'interpolation:  %(k1)s
"""),




    36 : _(u"""
 GROUP_MA_INTERF: un élément n'est ni tria3 ni tria6 ni QUAD4 ni QUAD8
"""),

    37 : _(u"""
 GROUP_MA_FLU_STR: un élément n'est ni tria3 ni tria6 ni QUAD4 ni QUAD8
"""),

    38 : _(u"""
 GROUP_MA_FLU_SOL: un élément n'est ni tria3 ni tria6 ni QUAD4 ni QUAD8
"""),

    39 : _(u"""
 GROUP_MA_SOL_SOL: un élément n'est ni tria3 ni tria6 ni QUAD4 ni QUAD8
"""),





    47 : _(u"""
  Le fichier " %(k1)s " n'est relié a aucune unité logique.
"""),




    52 : _(u"""
 ajout de l'option "SIEF_ELGA", les charges sont-elles correctes ?
"""),

    53 : _(u"""
 Le nombre maximum d'itérations est atteint.
"""),

    54 : _(u"""
  La dimension de l'espace doit être inférieur ou égal à 3.
"""),

    55 : _(u"""
 les points du nuage de départ sont tous en (0.,0.,0.).
"""),

    56 : _(u"""
 le nuage de départ est vide.
"""),

    57 : _(u"""
 les points du nuage de départ sont tous confondus.
"""),

    58 : _(u"""
 les points du nuage de départ sont tous alignes.
"""),

    59 : _(u"""
 les points du nuage de départ sont tous coplanaires.
"""),

    60 : _(u"""
 méthode inconnue :  %(k1)s
"""),

    61 : _(u"""
 le descripteur_grandeur de COMPOR ne tient pas sur un seul entier_code
"""),

    62 : _(u"""
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    63 : _(u"""
La composante n'a pas été affectée pour la grandeur.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    66 : _(u"""
 pas assez de valeurs dans la liste.
"""),

    67 : _(u"""
 il faut des triplets de valeurs.
"""),

    68 : _(u"""
 il n'y a pas un nombre pair de valeurs.
"""),

    69 : _(u"""
 nombre de valeurs différent  pour "NOEUD_PARA" et "VALE_Y"
"""),

    70 : _(u"""
 il manque des valeurs dans  %(k1)s  ,liste plus petite que  %(k2)s
"""),

    71 : _(u"""
La fonction a des valeurs négatives. Ce n'est pas compatible avec une
interpolation "LOG".

Conseil :
    Vous pouvez forcer le type d'interpolation de la fonction produite
    avec le mot-clé INTERPOL (ou INTERPOL_FONC quand il s'agit de nappe).
"""),

    72 : _(u"""
Les paramètres de la nappe ne sont pas croissants !
"""),

    75 : _(u"""
Les listes NUME_LIGN et LISTE_R/LISTE_K/LISTE_I doivent contenir le même nombre de termes.
"""),

    76 : _(u"""
Les noms de paramètres doivent être différents
"""),

    77 : _(u"""
 les listes d'abscisses et d'ordonnées doivent être de mêmes longueurs
"""),

    78 : _(u"""
 fonction incompatible avec  %(k1)s
"""),

    79 : _(u"""
 les noms de chaque paramètre doivent être différents
"""),

    84 : _(u"""
 la fonction doit s appuyée sur un maillage pour lequel une abscisse curviligne est définie.
"""),

    85 : _(u"""
 mauvaise définition des noeuds début et fin
"""),

    86 : _(u"""
 le nombre de champs à lire est supérieur a 100
"""),

    94 : _(u"""
  Le champ %(k1)s n'est pas prévu.
  Vous pouvez demander l'évolution.
"""),

    95 : _(u"""
  %(k1)s  et  %(k2)s  : nombre de composantes incompatible.
"""),

    97 : _(u"""
Erreur Utilisateur :
  On n'a pu lire aucun champ dans le fichier.
  La structure de données créée est vide.

Risques & Conseils :
  Si le fichier lu est au format IDEAS, et si la commande est LIRE_RESU,
  le problème vient peut-être d'une mauvaise utilisation (ou d'une absence d'utilisation)
  du mot clé FORMAT_IDEAS. Il faut examiner les "entêtes" des DATASET du fichier à lire.
"""),

}
