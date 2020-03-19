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

cata_msg = {

    4 : _("""
 Il y a un problème pour récupérer les variables d'accès.
"""),

    5 : _("""
 Seules les variables d'accès réelles sont traitées.
"""),

    6 : _("""
 Seuls les paramètres réels sont traités.
"""),

    7 : _("""
 L'unité logique est inexistante.
"""),

    8 : _("""
  Les fonctions à une seule variable sont admises.
"""),

    10 : _("""
  Les fonctions de type " %(k1)s " ne sont pas encore imprimées.
"""),

    11 : _("""
  Les fonctions de type " %(k1)s " ne sont pas imprimées.
"""),

    13 : _("""
 interpolation " %(k1)s " inconnue
"""),

    14 : _("""
 " %(k1)s " type de fonction inconnu
"""),

    17 : _("""
 on ne connaît pas ce type d'interpolation:  %(k1)s
"""),

    18 : _("""
 Erreur:
     Vous utilisez CREA_TABLE LISTE/LISTE_CO pour créer une table à 
     partir d'une liste de concepts. Or, TYPE_TABLE n'a pas la 
     valeur TYPE_TABLE='TABLE_CONTENEUR'.  
 Conseil: 
     Il est obligatoire de renseigner TYPE_TABLE='TABLE_CONTENEUR'.
"""),

    19 : _("""
 Erreur:
     Vous utilisez CREA_TABLE LISTE/LISTE_CO pour créer une table à 
     partir d'une liste de concepts. Or, vous n'avez pas fourni de 
     liste de paramètre NOM_OBJET contenant une clé unique pour chaque 
     concept présent dans la liste de concepts.   
 Conseil: 
     Il est obligatoire de définir une liste de paramètre NOM_OBJET 
     contenant une clé unique pour chaque concept présent dans la liste
     de concepts.
"""),

    36 : _("""
 GROUP_MA_INTERF: un élément n'est ni tria3 ni tria6 ni QUAD4 ni QUAD8
"""),

    37 : _("""
 GROUP_MA_FLU_STR: un élément n'est ni tria3 ni tria6 ni QUAD4 ni QUAD8
"""),

    38 : _("""
 GROUP_MA_FLU_SOL: un élément n'est ni tria3 ni tria6 ni QUAD4 ni QUAD8
"""),

    39 : _("""
 GROUP_MA_SOL_SOL: un élément n'est ni tria3 ni tria6 ni QUAD4 ni QUAD8
"""),





    47 : _("""
  Le fichier " %(k1)s " n'est relié a aucune unité logique.
"""),




    52 : _("""
 ajout de l'option "SIEF_ELGA", les charges sont-elles correctes ?
"""),

    53 : _("""
 Le nombre maximum d'itérations est atteint.
"""),

    54 : _("""
  La dimension de l'espace doit être inférieur ou égal à 3.
"""),

    55 : _("""
 les points du nuage de départ sont tous en (0.,0.,0.).
"""),

    56 : _("""
 le nuage de départ est vide.
"""),

    57 : _("""
 les points du nuage de départ sont tous confondus.
"""),

    58 : _("""
 les points du nuage de départ sont tous alignes.
"""),

    59 : _("""
 les points du nuage de départ sont tous coplanaires.
"""),

    60 : _("""
 méthode inconnue :  %(k1)s
"""),

    61 : _("""
 le descripteur_grandeur de COMPOR ne tient pas sur un seul entier_code
"""),

    62 : _("""
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    63 : _("""
La composante n'a pas été affectée pour la grandeur.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    66 : _("""
 pas assez de valeurs dans la liste.
"""),

    67 : _("""
 il faut des triplets de valeurs.
"""),

    68 : _("""
 il n'y a pas un nombre pair de valeurs.
"""),

    69 : _("""
 nombre de valeurs différent  pour "NOEUD_PARA" et "VALE_Y"
"""),

    70 : _("""
 il manque des valeurs dans  %(k1)s  ,liste plus petite que  %(k2)s
"""),

    71 : _("""
La fonction a des valeurs négatives. Ce n'est pas compatible avec une
interpolation "LOG".

Conseil :
    Vous pouvez forcer le type d'interpolation de la fonction produite
    avec le mot-clé INTERPOL (ou INTERPOL_FONC quand il s'agit de nappe).
"""),

    72 : _("""
Les paramètres de la nappe ne sont pas croissants !
"""),

    75 : _("""
Les listes NUME_LIGN et LISTE_R/LISTE_K/LISTE_I doivent contenir le même nombre de termes.
"""),

    76 : _("""
Les noms de paramètres doivent être différents, or %(k1)s a été utilisé plusieurs fois.
"""),

    77 : _("""
 les listes d'abscisses et d'ordonnées doivent être de mêmes longueurs
"""),

    78 : _("""
 fonction incompatible avec  %(k1)s
"""),

    79 : _("""
 les noms de chaque paramètre doivent être différents
"""),

    84 : _("""
 la fonction doit s appuyée sur un maillage pour lequel une abscisse curviligne est définie.
"""),

    85 : _("""
 mauvaise définition des noeuds début et fin
"""),

    86 : _("""
 le nombre de champs à lire est supérieur a 100
"""),

    95 : _("""
  %(k1)s  et  %(k2)s  : nombre de composantes incompatible.
"""),

    97 : _("""
Erreur Utilisateur :
  On n'a pu lire aucun champ dans le fichier.
  La structure de données créée est vide.

Risques & Conseils :
  Si le fichier lu est au format IDEAS, et si la commande est LIRE_RESU,
  le problème vient peut-être d'une mauvaise utilisation (ou d'une absence d'utilisation)
  du mot clé FORMAT_IDEAS. Il faut examiner les "entêtes" des DATASET du fichier à lire.
"""),

}
