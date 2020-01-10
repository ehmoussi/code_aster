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

from code_aster.Utilities import _

cata_msg = {

    1 : _("""
 erreur fortran de dimensionnement de tableau
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    2 : _("""
Il manque les coordonnées !
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    3 : _("""
Il manque les mailles !
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    4 : _("""
 transcodage : le noeud  %(k1)s  déclaré dans la connectivité de la maille  %(k2)s  n'existe pas dans les coordonnées
"""),

    5 : _("""
 transcodage : le noeud  %(k1)s  déclare dans le GROUP_NO:  %(k2)s  n'existe pas dans les coordonnées
"""),

    6 : _("""
 le noeud :  %(k1)s  est en double dans le GROUP_NO:  %(k2)s . on élimine les doublons
"""),

    7 : _("""
La maille  %(k1)s  déclaré dans le GROUP_MA %(k2)s  n'existe pas dans les connectivités
"""),

    8 : _("""
La maille  %(k1)s  est en double dans le GROUP_MA  %(k2)s . On élimine les doublons
"""),

    9 : _("""
Une incohérence a été détectée entre les déclarations de noms de noeuds ou de mailles lors du transcodage des objets groupes et connectivités
"""),


    36 : _("""
 un GROUP_MA n'a pas de nom, suppression de ce groupe.
"""),

    37 : _("""
 un GROUP_NO n'a pas de nom, suppression de ce groupe.
"""),

    40 : _("""
 absence de convergence
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    41 : _("""
 absence de convergence
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    42 : _("""
 pas de convergence
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    44 : _("""
 paramètre bêta non trouvé
"""),

    45 : _("""
 paramètre lambda non trouvé
"""),

    47 : _("""
 paramètre AFFINITE non trouvé
"""),





    49 : _("""
  -> La phase de vérification du maillage a été volontairement désactivée.

  -> Risque & Conseil :
     Soyez sur de votre maillage. Si des mailles dégénérées sont présentes elles
     ne seront pas détectées. Cela pourra nuire à la qualité des résultats.
"""),



    51 : _("""
DEFI_CABLE_BP : Échec de projection du noeud de câble %(k1)s.

La projection du noeud %(k1)s devrait très certainement être faite sur
la maille %(k2)s, cependant cette action est refusée car la distance
entre le noeud et la maille n'est pas compatible avec l'épaisseur
et l'excentricité de la maille.
Cette distance (orientée) doit être comprise entre %(r3)f et %(r2)f, or
la valeur calculée est %(r1)f.
"""),

    52 : _("""
La première maille du groupe %(k1)s sur lequel des caractéristiques de poutre
à section circulaire et homothétique sont affectés n'est pas correctement orientée.

Solution : réorienter les mailles du groupe avec MODI_MAILLAGE/ORIE_LIGNE.
"""),

    53 : _("""
La maille numéro %(i1)d du groupe %(k1)s sur lequel des caractéristiques de poutre
à section circulaire et homothétique sont affectés n'est pas connectée à la maille
précédente ou n'est pas orientée de la même manière.

Conseil et solution :
    - vérifier que les mailles sont correctement ordonnées dans le groupe
    définissant la poutre
    - réorienter les mailles du groupe avec MODI_MAILLAGE/ORIE_LIGNE.
"""),

    54 : _("""
Poutre circulaire à section homothétique :
La présence de la caractéristique %(k1)s est obligatoire.
"""),

    56 : _("""
 il manque le mot clé facteur POUTRE.
"""),

    57 : _("""
 erreur(s) rencontrée(s) lors de la vérification des affectations.
"""),

    59 : _("""
 une erreur d affectation a été détectée : certaines mailles demandées possèdent un type élément incompatible avec les données a affecter
"""),

    60 : _("""
 des poutres ne sont pas affectées
"""),

    61 : _("""
 des barres ne sont pas affectées
"""),

    62 : _("""
 des câbles ne sont pas affectes
"""),

    63 : _("""
 le paramètre "RHO" n'est pas défini pour toutes les couches.
"""),

    64 : _("""
 Il ne faut qu'un comportement élastique.
"""),

    65 : _("""
 <FAISCEAU_TRANS> deux zones d excitation du fluide ont même nom
"""),

    66 : _("""
 SPEC_EXCI_POINT : si INTE_SPEC alors autant d arguments pour NATURE, ANGLE et NOEUD (ou GROUP_NO)
"""),

    67 : _("""
 %(k1)s : On doit fournir un unique noeud , il y en a : %(i1)d
"""),

    68 : _("""
 SPEC_FONC_FORME : le nombre de fonctions fournies doit être égal a la dimension de la matrice interspectrale
"""),

    69 : _("""
 SPEC_EXCI_POINT : le nombre d arguments pour NATURE, ANGLE et NOEUD (ou GROUP_NO) doit être égal a la dimension de la matrice interspectrale
"""),

    70 : _("""
 mauvaise définition de la plage  de fréquence.
"""),

    71 : _("""
 mauvaise définition de la plage de fréquence. les modèles ne tolèrent pas des valeurs négatives ou nulles.
"""),

    72 : _("""
 le nombre de points pour la discrétisation fréquentielle doit être une puissance de 2.
"""),

    73 : _("""
 les spectres de type "longueur de corrélation"  ne peuvent être combines avec des spectres d un autre type.
"""),

    74 : _("""
 le spectre de nom  %(k1)s  est associe a la zone  %(k2)s  qui n existe pas dans le concept  %(k3)s
"""),

    75 : _("""
 le spectre de nom  %(k1)s  est associe a la zone de nom  %(k2)s
"""),

    76 : _("""
 deux spectres sont identiques
"""),

    77 : _("""
 les spectres de noms  %(k1)s  et  %(k2)s  sont associes au même profil de vitesse, de nom  %(k3)s
"""),

    78 : _("""
 pas le bon numéro de mode
"""),

    79 : _("""
 le calcul de tous les interspectres de réponse modale n est pas possible car seuls les auto spectres d excitation ont été calcules.
"""),

    80 : _("""
 la composante sélectionnée pour la restitution en base physique des interspectres est différente de celle choisie pour le couplage fluide-structure.
"""),

    81 : _("""
 la table de réponse modale ne contient que des auto spectres. le calcul demande n est donc pas réalisable.
"""),

    82 : _("""
 mot-clé <DEFI_CABLE>, occurrence no  %(i1)d :
    soit le noeud de câble  %(k1)s n'appartient pas au béton (modélisé en coque),
    soit les mailles de béton autour de ce noeud sont trop déformées.
"""),

    83 : _("""
 mot-clé <DEFI_CABLE>, occurrence no  %(k1)s , opérande <NOEUD_ANCRAGE> : il faut définir 2 noeuds d'ancrage
"""),

    84 : _("""
 mot-clé <DEFI_CABLE>, occurrence no  %(k1)s , opérande <GROUP_NO_ANCRAGE> : il faut définir 2 GROUP_NO d'ancrage
"""),

    85 : _("""
 mot-clé <DEFI_CABLE>, occurrence no  %(k1)s , opérande <NOEUD_ANCRAGE> : les 2 noeuds d'ancrage doivent être distincts
"""),

    86 : _("""
 mot-clé <DEFI_CABLE>, occurrence no  %(k1)s , opérande <GROUP_NO_ANCRAGE> : les 2 GROUP_NO d'ancrage doivent être distincts
"""),

    87 : _("""
 mot-clé <DEFI_CABLE>, occurrence no  %(k1)s , opérande type ancrage : les 2 extrémités sont passives -> armature passive
"""),

    88 : _("""
 mot-clé <DEFI_CABLE>, occurrence no  %(k1)s , opérande type ancrage : les 2 extrémités sont passives et la tension que vous voulez imposer est non nulle : impossible !
"""),

    89 : _("""
 la carte des caractéristiques matérielles des éléments n existe pas. il faut préalablement affecter ces caractéristiques en utilisant la commande <AFFE_MATERIAU>
"""),

    90 : _("""
 la carte des caractéristiques géométriques des éléments de barre de section générale n existe pas. il faut préalablement affecter ces caractéristiques en utilisant la commande <AFFE_CARA_ELEM>
"""),

    91 : _("""
 problème pour déterminer le rang de la composante de la grandeur
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    92 : _("""
 Erreur de mise en données :
 Le mot clé ORIE_LIGNE ne traite que les mailles linéiques.
 Or, des mailles surfaciques ont été fournies.
"""),

    93 : _("""
 Erreur de mise en données :
 Le mot clé ORIE_LIGNE ne traite que les mailles linéiques.
 La maille %(k1)s est de type %(k2)s.
"""),

    94 : _("""
 impossibilité, la maille  %(k1)s  doit être une maille de peau, i.e. de type "QUAD" ou "tria" en 3d ou de type "SEG" en 2d, et elle est de type :  %(k2)s
"""),

    95 : _("""
 Vous avez utilisé le mot clé ORIE_PEAU_2D alors que le problème est tridimensionnel. utilisez ORIE_PEAU_3D
 Il est possible que votre maillage soit plan, mais que les noeuds possèdent 3 coordonnées. """),

    96 : _("""
 vous avez utilisé le mot clé ORIE_PEAU_3D alors que le problème est 2d. utilisez ORIE_PEAU_2D
"""),

    97 : _("""
 erreur données : le noeud  %(k1)s  n'existe pas
"""),

    98 : _("""
 impossibilité de mélanger des "SEG" et des "TRIA" ou "QUAD" !
"""),

    99 : _("""
 Lors de la vérification automatique de l'orientation des mailles de bord, une erreur a été rencontrée : les groupes de mailles de bord ne forment pas un ensemble connexe.

 Conseils :
 - Commencez par vérifier que les groupes de mailles de bord fournies sont correctement définis.
 - Si ces groupes de mailles ont des raisons d'être non connexes, vous pouvez désactiver la vérification automatique en renseignant VERI_NORM='NON'.
"""),

}
