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
La charge %(k1)s a été utilisée plus d'une fois dans EXCIT: il faut la supprimer.
"""),

    2 : _("""
Il n'y a aucune charge dans le mot-clef facteur EXCIT. Ce n'est pas possible avec STAT_NON_LINE.
"""),

    3 : _("""
La charge %(k1)s n'a pu être identifiée. Cette erreur est probablement due à l'utilisation d'un
mot-clef facteur vide dans l'opérateur AFFE_CHAR_MECA, AFFE_CHAR_THER ou AFFE_CHAR_ACOU.
"""),

    4 : _("""
Le type de chargement PRE_EPSI renseigné par fonction (via AFFE_CHAR_MECA_F) doit avoir la
même valeur aux deux noeuds d'un même élément de poutre.

Valeur au noeud 1 pour la composante %(k1)s : %(r1)f
Valeur au noeud 2 pour la composante %(k1)s : %(r2)f

Pour les poutres, le code ne sait pas encore traiter ce type de chargement variable sur l'élément.
"""),


    20 : _("""
La charge %(k1)s n'est pas compatible avec FONC_MULT.
"""),


    21 : _("""
La charge %(k1)s n'est pas thermique.
"""),

    22 : _("""
La charge %(k1)s n'est pas mécanique.
"""),

    23 : _("""
La charge %(k1)s a été déclarée comme étant suiveuse alors que ce n'est pas possible.
Si votre chargement contient plusieurs types dont certains ne peuvent être suiveurs, il faut les séparer.
Certains chargements ne peuvent être suiveurs s'ils sont dépendant du temps.
"""),

    24 : _("""
La charge %(k1)s est de type cinématique (AFFE_CHAR_CINE):
 elle ne peut pas être différentielle.
"""),

    26 : _("""
La charge %(k1)s a été déclarée comme étant pilotable alors que ce n'est pas possible.
Si votre chargement contient plusieurs types dont certains ne peuvent être pilotables, il faut les séparer.
"""),


    27 : _("""
La charge %(k1)s est de type cinématique (AFFE_CHAR_CINE): elle ne peut pas être pilotée.
"""),

    28 : _("""
On ne peut pas piloter la charge %(k1)s car c'est une charge fonction du temps.
"""),

    29 : _("""
Il y a trop de chargements de type Dirichlet suiveur.
"""),

    30 : _("""
Erreur utilisateur :
  Le chargement contient des relations cinématiques qui sont non-linéaires
  lorsque l'on utilise EXCIT / TYPE_CHARGE='SUIV'.
  Mais le code ne sait pas encore traiter ces relations non linéaires.
"""),

    31 : _("""
La charge %(k1)s est un chargement de type force ou flux et ne peut donc pas utiliser DIDI.
"""),

    32 : _("""
La charge %(k1)s contient une condition de type ECHANGE et elle n'est pas compatible avec FONC_MULT. Pour appliquer une fonction (y compris en fonction du temps), il faut utiliser AFFE_CHAR_THER_F.
"""),

    33 : _("""
Le modèle de la charge %(k1)s est différent du modèle de l'opérateur de calcul.
- modèle de la charge : %(k2)s
- modèle du calcul    : %(k3)s
"""),

    34 : _("""
La charge %(k1)s ne peut pas être pilotée.
"""),

    35 : _("""
Erreur utilisateur :
  Le chargement contient des relations cinématiques LIAISON_SOLIDE qui sont non-linéaires lorsque l'on utilise EXCIT / TYPE_CHARGE='SUIV'.
  Mais ce cas n'est pas traité car il y a au moins un noeud qui porte le degré de liberté DRZ.
"""),

    36 : _("""
Erreur utilisateur :
  Le chargement contient des relations cinématiques LIAISON_SOLIDE qui sont non-linéaires lorsque l'on utilise EXCIT / TYPE_CHARGE='SUIV'.
  Mais ce cas n'est pas traité car il y a au moins un noeud qui porte les degrés de liberté DRX, DRY et DRZ.
"""),

    38 : _("""
La charge %(k1)s ne peut pas utiliser de fonction multiplicatrice FONC_MULT
 car elle est pilotée.
"""),

    39 : _("""
On ne peut pas piloter en l'absence de forces de type FIXE_PILO.
"""),

    40 : _("""
On ne peut piloter plus d'une charge.
"""),

    50 : _("""
Le chargement FORCE_SOL n'est utilisable qu'en dynamique.
"""),

    51 : _("""
Le chargement FORCE_SOL ne peut pas être de type suiveur
"""),

    52 : _("""
Le chargement FORCE_SOL ne peut pas être de type Dirichlet différentiel.
"""),

    53 : _("""
Le chargement FORCE_SOL ne peut pas être une fonction.
"""),

    55 : _("""
La charge %(k1)s dépend de la vitesse: elle doit être suiveuse.
"""),

    56 : _("""
La charge %(k1)s dépend de la vitesse: elle ne peut être utilisable qu'en dynamique.
"""),

    57: _("""
    AFFE_CHAR_CINE:
Vous essayez d'appliquer un déplacement selon DZ à une modélisation qui n'est pas 3D.

Conseil: Vérifié vos conditions aux limites.
"""),


}
