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

from code_aster import _

cata_msg = {

    1 : _("""
 La modélisation C_PLAN n'est pas compatible avec la loi de comportement ELAS_VMIS_PUIS.
"""),

    3 : _("""
 type de matrice inconnu.
"""),

    13 : _("""
 le VECT_ELEM n'existe pas :  %(k1)s
"""),




    21 : _("""
 le noeud  %(k1)s  n'appartient pas au maillage :  %(k2)s
"""),

    25 : _("""
 données incompatibles.
"""),

    32 : _("""
  la numérotation n'est pas cohérente avec le modèle généralisé
  si vous avez activé l'option INITIAL dans NUME_DDL_GENE faites de même ici !
"""),


    35 : _("""
 les champs " %(k1)s " et " %(k2)s " n'ont pas le même domaine de définition.
"""),

    36 : _("""
 BARSOUM, erreur dans le traitement des mailles %(k1)s
"""),

    42 : _("""
 BETON_DOUBLE_DP: incrément de déformation plastique en traction négatif
 --> redécoupage automatique du pas de temps
"""),

    43 : _("""
 BETON_DOUBLE_DP: incrément de déformation plastique en compression négatif
 --> redécoupage automatique du pas de temps
"""),

    44 : _("""
 intégration élastoplastique de la loi BETON_DOUBLE_DP :
 la condition d'applicabilité sur la taille des éléments
 n'est pas respectée en compression.
"""),

    45 : _("""
 intégration élastoplastique de la loi BETON_DOUBLE_DP :
 la condition d'applicabilité sur la taille des éléments
 n'est pas respectée en compression pour la maille:  %(k1)s
"""),

    46 : _("""
 intégration élastoplastique de la loi BETON_DOUBLE_DP :
 la condition d'applicabilité sur la taille des éléments
 n est pas respectée en traction.
"""),

    47 : _("""
 intégration élastoplastique de la loi BETON_DOUBLE_DP :
 la condition d'applicabilité sur la taille des éléments
 n'est pas respectée en traction pour la maille:  %(k1)s
"""),

    48 : _("""
  -> Intégration élastoplastique de loi multicritères BETON_DOUBLE_DP :
     la contrainte équivalente est nulle pour la maille %(k1)s
     le calcul de la matrice tangente est impossible.
  -> Risque & Conseil :
"""),

    52 : _("""
  Le nombre de modes et de degré de liberté d'interface sont différents.
"""),

    53 : _("""
  Le nombre de modes dynamiques est %(i1)d,
  ce n'est pas un multiple du nombre de composante.
"""),

    54 : _("""
  Le nombre de modes statiques est %(i1)d,
  ce n'est pas un multiple du nombre de composante.
"""),





    60 : _("""
 certains coefficients de masse ajoutée sont négatifs.
 vérifiez l'orientation des normales des éléments d'interface.
 convention adoptée : structure vers fluide
"""),

    61 : _("""
 certains coefficients d'amortissement ajouté sont négatifs.
 possibilité d'instabilité de flottement
"""),

    68 : _("""
 trop de familles de systèmes de glissement.
 augmenter la limite actuelle (5)
"""),

    69 : _("""
 trop de familles de systèmes de glissement.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    70 : _("""
 Le nombre de système de glissement est égal à 0
"""),

    96 : _("""
 ce mot clé de MODI_MAILLAGE attend un vecteur de norme non nulle.
"""),

    97 : _("""
 le mot clé REPERE de MODI_MAILLAGE attend deux vecteurs non nuls orthogonaux.
"""),

}
