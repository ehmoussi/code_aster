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
 Problème d'orientation: aucune maille ne touche le noeud indiqué
"""),

    2 : _("""
 Certaines mailles n'ont pas pu être réorientées. L'ensemble des mailles n'est pas connexe.
"""),

    3 : _("""
 on ne trouve pas de noeud assez près du noeud  %(k1)s
"""),

    4 : _("""
  Erreurs dans les données
"""),

    5 : _("""
 Extraction de plus de noeuds que n'en contient la maille
"""),

    6 : _("""
  Nombre de noeuds négatif
"""),

    7 : _("""
 nombre de noeuds sommets non prévu
"""),

    8 : _("""
  on est sur 2 mailles orthogonales
"""),


    10 : _("""
 la maille  %(k1)s  ne fait pas partie du maillage  %(k2)s
"""),

    11 : _("""
 PREF_MAILLE est trop long, PREF_NUME est trop grand
"""),

    12 : _("""
 PREF_MAILLE est trop long
"""),

    13 : _("""
 Les %(i1)d noeuds imprimés ci-dessus n'appartiennent pas au modèle (c'est à dire
 qu'ils ne portent aucun degré de liberté) et pourtant ils ont été affectés dans
 le mot-clé facteur : %(k1)s
"""),


    14 : _("""
 DEFI_GEOM_FIBRE
 Le maillage %(k1)s ne contient aucun éléments valides pour définir des fibres.
 Il faut qu'il contienne des %(k2)s.
"""),

    17 : _("""
 AFFE_CARA_ELEM les groupes de fibres %(k1)s et %(k2)s ont une définition incompatible.
 L'utilisation des groupes fibres définis par DEFI_GEOM_FIBRE/SECTION ou DEFI_GEOM_FIBRE/FIBRE
 est incompatible avec DEFI_GEOM_FIBRE/ASSEMBLAGE_FIBRE.
 Ces groupes de fibres ne peuvent pas être affectés sur une même poutre multifibre.
"""),

    18 : _("""
 AFFE_CARA_ELEM le groupe de fibres %(k1)s n'existe pas.
 Conseil : Vérifier la définition des groupes fibres dans l'opérateur DEFI_GEOM_FIBRE.
"""),

    19 : _("""
 DEFI_GEOM_FIBRE le groupe de fibres %(k1)s est déjà défini.
"""),

    20 : _("""
 Ce type de maille n'est pas encore traité :  %(k1)s
"""),

    21 : _("""
 Le nombre total de noeuds est différent de la somme des noeuds sommets, arêtes et intérieurs
"""),

    22 : _("""
 Les deux listes %(k1)s  et  %(k2)s  ne sont pas de même longueur
"""),

    23 : _("""
 DEFI_GEOM_FIBRE %(k1)s : Pour %(k2)s il y a %(i1)d valeurs. Ce devrait être %(i2)d valeurs,
"""),

    24 : _("""
 DEFI_GEOM_FIBRE %(k1)s : Le %(k2)s %(k3)s n'existe pas.
"""),

    25 : _("""
 DEFI_GEOM_FIBRE %(k1)s : Le groupe de fibre %(k2)s doit être défini par SECTION ou FIBRE,
"""),

    26 : _("""
 DEFI_GEOM_FIBRE %(k1)s : Pour %(k2)s il y a %(i1)d valeurs, ce devrait être un multiple de %(i2)d
"""),

    27 : _("""
 Dans le maillage " %(k1)s " la maille " %(k2)s " est de type " %(k3)s " (ni TRIA3 ni QUAD4)
"""),

    28 : _("""
 Le noeud <%(k1)s> de la poutre, de coordonnées <%(r1)g  %(r2)g  %(r3)g>,
 ne doit pas appartenir à des mailles constituant la trace de la poutre sur la coque.
 Le problème vient de l'occurrence %(i1)d de LIAISON_ELEM.

Solution : Il faut dédoubler le noeud.
"""),

    29 : _("""
 Une maille des groupes modélisant la dalle a une dimension topologique différente
 de 1 et 2.
"""),

    30 : _("""
 L'indicateur : %(k1)s de position des multiplicateurs de Lagrange associés à
 une relation linéaire n'est pas correct.
"""),

    31 : _("""
  ->  En thermique, les fonctions définissant le matériau (enthalpie, capacité calorifique, conductivité)
      doivent obligatoirement être décrites par des fonctions tabulées et non des formules.
      En effet, on a besoin d'évaluer la dérivée de ces fonctions. Elle peut être plus facilement et
      précisément obtenue pour une fonction linéaire par morceaux que pour une expression 'formule'.
  -> Conseil:
      Tabulez votre formule, à une finesse de discrétisation d'abscisse (TEMP) à votre convenance,
      par la commande CALC_FONC_INTERP
 """),

    32 : _("""
 impossibilité, le noeud  %(k1)s ne porte le degré de liberté de rotation %(k2)s
"""),

    33 : _("""
 il faut COEF_GROUP ou FONC_GROUP
"""),

    34 : _("""
 un élément n'est ni TRIA3 ni TRIA6 ni QUAD4 ni QUAD8
"""),

    35 : _("""
 Les mailles des groupes modélisant la dalle ne sont pas toutes de même
 dimension topologique (RIGI_PARASOL)
"""),

    36 : _("""
  le noeud  %(k1)s  doit appartenir à une seule maille
"""),

    37 : _("""
 la maille à laquelle appartient le noeud  %(k1)s  doit être de type SEG3
"""),

    38 : _("""
 on ne trouve pas les angles nautiques pour le tuyau
"""),

    39 : _("""
 option  %(k1)s  invalide
"""),

    40 : _("""
Erreur utilisateur pour LIAISON_ELEM / OPTION='3D_POU' (ou OPTION='2D_POU').
Il faut que les mots clés GROUP_NO_2, NOEUD_2, GROUP_MA_2 ou MAILLE_2 ne
désignent qu'un seul noeud.
On trouve %(i1)d noeuds.
"""),



    43 : _("""
 il ne faut donner qu'un seul noeud dans le GROUP_NO :  %(k1)s
"""),

    44 : _("""
 impossibilité, le noeud  %(k1)s porte le degré de liberté de rotation  %(k2)s
"""),

    45 : _("""
 impossibilité, le noeud poutre  %(k1)s  devrait porter le degré de liberté  %(k2)s
"""),

    46 : _("""
 impossibilité, la surface de raccord du massif est nulle
"""),

    47 : _("""
 il faut donner un CARA_ELEM pour récupérer les caractéristiques de tuyau.
"""),

    48 : _("""
 il faut indiquer le mot-clé 'NOEUD_2' ou 'GROUP_NO_2' après le mot-clé facteur  %(k1)s  pour l'option  %(k2)s
"""),

    49 : _("""
 il ne faut donner qu'un seul noeud de poutre à raccorder à la coque.
"""),

    50 : _("""
 il ne faut donner qu'un seul GROUP_NO à un noeud à raccorder à la coque.
"""),

    51 : _("""
 il faut donner un vecteur orientant l'axe de la poutre sous le mot-clé "AXE_POUTRE".
"""),

    52 : _("""
 il faut donner un vecteur non nul orientant l'axe de la poutre sous le mot-clé "AXE_POUTRE".
"""),

    53 : _("""
 il faut donner un CARA_ELEM pour récupérer l'épaisseur des éléments de bord.
"""),

    54 : _("""
 impossibilité, le noeud  %(k1)s ne porte pas le degré de liberté de rotation  %(k2)s
"""),

    55 : _("""
 impossibilité, la surface de raccord de la coque est nulle
"""),

    58 : _("""
 BETA et RHO_CP ne peuvent pas être définies avec des nappes (mot-clé THER_NL).
"""),

    64 : _("""
Type non traité:  %(k1)s
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    70 : _("""
 erreur lors de la définition de la courbe de traction, il manque le paramètre : %(k1)s
"""),

    71 : _("""
 erreur lors de la définition de la courbe de traction : %(k1)s  nombre de points < 2  !
"""),

    72 : _("""
 erreur lors de la définition de la courbe de traction : %(k1)s  nombre de points < 1  !
"""),

    73 : _("""
 erreurs rencontrées.
"""),

    74 : _("""
 erreur lors de la définition de la nappe des courbes de traction: nombre de points < 2 !
"""),

    75 : _("""
 erreur lors de la définition de la nappe des courbes de traction:  %(k1)s  nombre de points < 1 !
"""),

    76 : _("""
  erreur lors de la définition de la courbe de traction: FONCTION ou NAPPE !
"""),

    80 : _("""
 comportement TRACTION non trouvé
"""),

    81 : _("""
Erreur programmeur dans DEFI_MATERIAU :
   Pour le mot clé facteur %(k1)s, la liste ordonnée des mots clés (ORDRE_PARAM)
   ne contient pas le mot clé %(k2)s.
"""),


    82 : _("""
 comportement META_TRACTION non trouvé
"""),

    83 : _("""
 fonction SIGM_F1 non trouvée
"""),

    84 : _("""
 fonction SIGM_F2 non trouvée
"""),

    85 : _("""
 fonction SIGM_F3 non trouvée
"""),

    86 : _("""
 fonction SIGM_F4 non trouvée
"""),

    87 : _("""
 fonction SIGM_C non trouvée
"""),

    88 : _("""
 fonction constante interdite pour la courbe de traction %(k1)s
"""),

    89 : _("""
 prolongement à gauche EXCLU pour la courbe  %(k1)s
"""),

    90 : _("""
 prolongement à droite EXCLU pour la courbe  %(k1)s
"""),

    91 : _("""
 concept de type :  %(k1)s  interdit pour la courbe de traction %(k2)s
"""),

    92 : _("""
Erreur utilisateur dans DEFI_MATERIAU :
  Lorsque le coefficient de dilatation RHO est une fonction, il
  ne peut être qu'une fonction de la géométrie (X,Y,Z).
  La fonction %(k1)s dépend du paramètre %(k2)s.
  C'est interdit.
"""),

    93 : _("""
  les fonctions complexes ne sont pas implémentées
"""),

    94 : _("""
 Le nombre de paramètres est supérieur à 30 pour le matériau  %(k1)s
"""),

    95 : _("""
 mauvaise définition de la plage de fréquence, aucun mode pris en compte
"""),

    96 : _("""
 les %(i1)d mailles imprimées ci-dessus n'appartiennent pas au modèle
 et pourtant elles ont été affectées dans le mot-clé facteur : %(k1)s
"""),

    97 : _("""
 FREQ INIT plus grande que FREQ FIN
"""),

    98 : _("""
 FREQ INIT nécessaire avec CHAMNO
"""),

    99 : _("""
 FREQ FIN nécessaire avec CHAMNO
"""),

}
