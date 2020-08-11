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

    1: _("""
 les 2 maillages ne sont pas du même type : 2D (ou 3D).
"""),

    2: _("""
 la (super)maille :  %(k1)s  est en double.
"""),

    3: _("""
 la maille :  %(k1)s  est en double.
"""),

    4: _("""
 le GROUP_MA :  %(k1)s  est en double. on ignore le second.
"""),

    5: _("""
 le GROUP_NO :  %(k1)s  est en double. on ignore le second.
"""),

    6: _("""
 le noeud: %(k1)s  n'a pas les mêmes coordonnées dans les maillages:  %(k2)s  et  %(k3)s
"""),

    7: _("""
 matrice de rigidité non inversible (modes rigides ???)
 - attention : critères de choc non calculés
"""),

    8: _("""
 matrice de rigidité : pivot quasi nul (modes rigides ???)
 - attention : critères de choc non calculés
"""),

    9: _("""
 mot-clef "DEFINITION" interdit :
 le MACR_ELEM :  %(k1)s  est déjà défini.
"""),

    10: _("""
 mot-clef "RIGI_MECA" interdit :
 il est déjà calculé.
"""),

    11: _("""
 mot-clef "RIGI_MECA" interdit :
 le résultat :  %(k1)s  existe déjà.
"""),

    12: _("""
 mot-clef "MASS_MECA" interdit :
 il faut avoir fait "DEFINITION" et "RIGI_MECA".
"""),

    13: _("""
 mot-clef "MASS_MECA" interdit :
 il est déjà calculé.
"""),

    14: _("""
 mot-clef "CAS_CHARGE" interdit :
 il faut avoir fait "DEFINITION" et "RIGI_MECA".
"""),

    15: _("""
 cet opérateur modifie un maillage existant
 le résultat doit être identique au concept donné dans l'argument MAILLAGE.
"""),

    16: _("""
 maillages avec super mailles :
 utiliser OPERATION = SOUS_STRUC
"""),

    20: _("""
 vecteur nul pour l'orientation
"""),

    21: _("""
 critère inconnu
"""),

    22: _("""
 noeud %(k1)s trop éloigné de la normale au segment
 distance = %(r1)f
 
 si vous rencontrez cette alarme dans le cadre de l'utilisation de la 
 commande DEFI_GROUP, elle est associée au mot-clé PRECISION de 
 l'option SEGM_DROI_ORDO.
 si vous rencontrez cette alarme dans le cadre de l'utilisation de la 
 commande POST_RELEVE_T, elle est associée au mot-clé PRECISION.
 si vous rencontrez cette alarme dans le cadre de l'utilisation de la 
 commande DEFI_FOND_FISS, elle est associée au mot-clé PREC_NORM.
"""),

    23: _("""
  On cherche à classer une liste de noeuds par abscisses croissantes
  de leur projection sur un segment de droite.
  2 noeuds ont la même projection sur la droite.
  Le classement est donc arbitraire.

  -> Risque & Conseil :
     Vérifiez votre maillage.
"""),

    24: _("""
 mot clef "SOUS_STRUC" interdit pour ce modèle sans sous-structures.
"""),

    25: _("""
 liste de mailles plus longue que la liste des sous-structures du modèle.
"""),

    26: _("""
 la maille :  %(k1)s  n existe pas dans le maillage :  %(k2)s
"""),

    27: _("""
 la maille :  %(k1)s  n'est pas active dans le modèle
"""),

    28: _("""
 la maille :  %(k1)s  ne connaît pas le chargement :  %(k2)s
"""),

    29: _("""
 arrêt suite aux erreurs détectées.
"""),

    30: _("""
 mot clef "AFFE_SOUS_STRUC" interdit pour ce maillage sans (super)mailles.
"""),

    31: _("""
 la maille :  %(k1)s  n'appartient pas au maillage
"""),

    32: _("""
 maille en double :  %(k1)s  dans le GROUP_MA:  %(k2)s
"""),

    33: _("""
 l'indice final est inférieur a l'indice initial
"""),

    34: _("""
 l'indice final est supérieur a la taille du groupe
"""),

    35: _("""
 le GROUP_MA :  %(k1)s  n'appartient pas au maillage
"""),

    36: _("""
 le GROUP_MA : %(k1)s est vide. on ne le crée pas.
"""),

    37: _("""
 Le groupe de noeuds '%(k1)s' existe déjà.

 Conseil :
    Si vous souhaitez utiliser un nom de groupe existant, il suffit
    de le détruire avec DEFI_GROUP / DETR_GROUP_NO.
"""),


    38: _("""
 le GROUP_NO : %(k1)s  est vide, on ne le crée pas.
"""),

    39: _("""
 noeud en double :  %(k1)s  dans le GROUP_NO:  %(k2)s
"""),

    40: _("""
 liste de charges trop longue
"""),

    41: _("""
 l'extérieur du MACR_ELEM_STAT contient des noeuds qui ne portent aucun ddl, ces noeuds sont éliminés.
"""),

    42: _("""
 l'extérieur du MACR_ELEM_STAT contient des noeuds en double. ils sont éliminés.
"""),

    43: _("""
 grandeur:  %(k1)s  interdite. (seule autorisée: DEPL_R)
"""),

    44: _("""
 la maille :  %(k1)s  n existe pas dans le maillage : %(k2)s
"""),

    45: _("""
 numéro. équation incorrect
"""),

    46: _("""
 cas de charge :  %(k1)s  inexistant sur le MACR_ELEM_STAT :  %(k2)s
"""),

    47: _("""
 erreur programmeur 1
"""),

    48: _("""
 noeud :  %(k1)s  inexistant dans le maillage :  %(k2)s
"""),

    49: _("""
 GROUP_NO :  %(k1)s  inexistant dans le maillage :  %(k2)s
"""),

    50: _("""
 liste de mailles trop longue.
"""),

    51: _("""
 la liste des mailles est plus longue que la liste des MACR_ELEM_STAT.
"""),

    52: _("""
 trop de réels pour le mot clef "TRAN"
"""),

    53: _("""
 trop de réels pour le mot clef "ANGL_NAUT"
"""),

    54: _("""
 trop de réels pour le mot clef "centre"
"""),

    55: _("""
 mélange de maillages 2d et 3d
"""),

    56: _("""
  le MACR_ELEM_STAT : %(k1)s  n'existe pas.
"""),

    57: _("""
 les arguments "préfixe" et "index" conduisent a des noms de noeuds trop longs (8 caractères max).
"""),

    58: _("""
 il faut : "tout" ou "maille" pour "DEFI_NOEUD".
"""),

    59: _("""
  le noeud :  %(k1)s  n'appartient pas a la maille : %(k2)s
"""),

    60: _("""
  le noeud :  %(k1)s  de la maille :  %(k2)s  a été éliminé (recollement). on ne peut donc le renommer.
"""),

    61: _("""
 les arguments "préfixe" et "index" conduisent a des noms de GROUP_NO trop longs (8 caractères max).
"""),

    62: _("""
 le GROUP_NO :  %(k1)s  est vide. on ne le crée pas.
"""),

    63: _("""
 liste trop longue
"""),

    64: _("""
 la liste de mailles est plus longue que le nombre total de mailles.
"""),

    65: _("""
 la liste de mailles  n'a pas la même longueur que la liste de GROUP_NO.
"""),

    66: _("""
 la liste de mailles  doit être de dimension au moins 2 pour le recollement
"""),

    67: _("""
 les GROUP_NO a recoller :  %(k1)s  et  %(k2)s  n'ont pas le même nombre de noeuds.
"""),

    68: _("""
 pour le recollement géométrique des GROUP_NO :  %(k1)s  et  %(k2)s  certains noeuds ne sont pas apparies
"""),

    69: _("""
 AMOR_MECA non implante.
"""),

    70: _("""
 la sous-structuration n'est possible qu'en mécanique
"""),

    71: _("""
 nombre de noeuds internes : 0
"""),

    73: _("""
 la grandeur "DEPL_R" doit avoir les composantes (1 a 6) : DX,DY, ..., DRZ
"""),

    74: _("""
 la grandeur "DEPL_R" doit avoir la composante "LAGR".
"""),

    75: _("""
La valeur  %(k1)s n'est pas autorisée.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    76: _("""
 ddl non prévu. on attend: DX
"""),

    77: _("""
 ddls non prévus
"""),

    79: _("""
 le calcul de réponse pour ce type de résultat n'est disponible que sur les MACR_ELEM_STAT obtenus a partir de la mesure
"""),

    80: _("""
 la matrice de rigidité condensée n'a pas été calculée
"""),

    81: _("""
 la matrice de masse condensée n'a pas été calculée
"""),

    82: _("""
 nombre de ddl capteur insuffisant ou nombre vecteurs de base trop élevé, nombre ddl capteur : %(i1)d ,nombre vecteurs de base : %(i2)d
"""),

    83: _("""
 nombre ddl interface insuffisant ou nombre modes identifies trop élevé, nombre ddl interface : %(i1)d ,nombre modes identifies : %(i2)d
"""),

    84: _("""
Cette fonctionnalité n'est pas disponible pour les modes complexes.
    """),

    85: _("""
  au noeud de choc:  %(k1)s
"""),

    86: _("""
 noeud   %(k1)s   en dehors du segment %(k2)s   abscisse curviligne %(r1)f
"""),

    87: _("""
 Le groupe de noeuds %(k1)s contient plus qu'un seul noeud.
 Noeud utilisé pour réaliser l'opération demandée :  %(k2)s
"""),


    93: _("""
    pour le mode no : %(i1)d taux de flexibilité locale   :  %(r1)f
 souplesse locale             :  %(r2)f
 taux effort tranchant local  :  %(r3)f

"""),

    94: _("""
   -- bilan noeud de choc : %(k1)s  taux de restitution flexibilité      :  %(r1)f
  taux de restitution effort tranchant :  %(r2)f
"""),

    95: _("""
  ( souplesse statique - souplesse locale )/ souplesse choc :  %(r1)f
"""),

    96: _("""
  souplesse locale / souplesse choc :  %(r1)f
"""),

    98: _("""
 !! attention plus petite val singulière déformation statique :  %(r1)f !! nous la forçons a :  %(r2)f
"""),

    99: _("""
 ---- conditionnement déformation statique :  %(r1)f
"""),

}
