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


    2 : _(u"""Dans le KIT_DDI, on ne peut pas coupler GRANGER avec %(k1)s."""),

    3 : _(u"""Dans le KIT_DDI, on ne peut pas coupler BETON_UMLV avec %(k1)s."""),

    4 : _(u"""Dans le KIT_DDI, on ne peut pas coupler GLRC avec %(k1)s."""),

    6 : _(u"""Dans le KIT_DDI, la loi de fluage %(k1)s n'est pas autorisée."""),

    8 : _(u"""Vous avez demandé à utiliser un comportement avec des phases métallurgiques de type %(k1)s, mais le matériau est défini avec des variables de commande de type %(k2)s."""),

    11 : _(u"""
 Produit scalaire presque nul entre les vecteurs :
                %(r1)f
                %(r2)f
            et
                %(r3)f
                %(r4)f
"""),

    12 : _(u"""
 Erreur lors de la diagonalisation de la matrice :
                %(r1)f, %(r2)f, %(r3)f
                %(r4)f, %(r5)f, %(r6)f
                %(r7)f, %(r8)f, %(r9)f
"""),

    13 : _(u"""
 Norme nulle, matrice à diagonaliser :
                %(r1)f, %(r2)f, %(r3)f
                %(r4)f, %(r5)f, %(r6)f
                %(r7)f, %(r8)f, %(r9)f
"""),

    14 : _(u"""
 Ne devrait pas être nul
 mise à zéro de la pression capillaire
"""),

    15 : _(u"""
 Attention  %(r1)f
"""),

    16 : _(u"""
 Problème de dimension des variables internes, %(i1)d != %(i2)d
"""),

    17 : _(u"""
 Cas de pression intraporeuse imprévue : %(r1)f %(r2)f
"""),

    18 : _(u"""
 Delta plus grand que la racine carrée de 3 : impossible 
"""),

    19 : _(u"""
 DP atteignable par traction tri-axiale
 Augmenter RC ou diminuer RT effective 
                RT = %(r1)f
                RC = %(r2)f
                RC minimum = %(r3)f
"""),

    20 : _(u"""
 Sous itération radiale désactivée
 contrôler direction écoulement
"""),

    21 : _(u"""
 TAU < TAU limite/1000
 Atteinte du critère DP sans cisaillement
                valeur réelle = %(r1)f
                valeur adoptée = %(r2)f
"""),

    22 : _(u"""
 critère DP annulé alors que %(r1)f >%(r2)f
"""),

    23 : _(u"""
 Dilatance excessive > %(r1)f
"""),


    25 : _(u"""
 Il est préférable que BG.Mg(%(r1)f) < %(r2)f
"""),

    26 : _(u"""
 Problème lors du tir viscoélastique dans FLUA_ENDO_PORO
"""),

    27 : _(u"""
 Nombre d'itération maximum atteint :  %(i1)d
"""),

    28 : _(u"""
 FLUA_ENDO_PORO : cas élasticité anisotrope
 Changement de base pour la loi de comportement non programmé
"""),

    29 : _(u"""
 FLUA_ENDO_PORO : cas élasticité anisotrope
 Changement de base résistances non programmé
"""),

    30 : _(u"""
  FLUA_ENDO_PORO : problème dans la résolution du retour radial
"""),

    31 : _(u"""
 FLUA_ENDO_PORO : nombre maximum de sous itération atteint : %(i1)d
"""),

    32 : _(u"""
 Critère non prévu dans fluage3d
"""),

    33 : _(u"""
 FLUA_ENDO_PORO : nombre d'itération maximum %(i1)d atteint :
             compteur de sous itération plastique = %(i1)d
             nombre d'itération multiplicateur < 0 = %(i1)d
             
 Essayez de réduire la vitesse de chargement ou augmentez le nombre d'itérations maximum

"""),

    34 : _(u"""
 FLUA_ENDO_PORO : erreur 
"""),

    35 : _(u"""
 Taille du problème trop grand %(i1)d et %(i1)d
"""),

    36 : _(u"""
 FLUA_ENDO_PORO : pivot nul dans gauss_3d :
            pivot maximum = %(r1)f
            ligne = %(i1)d
"""),

    37 : _(u"""
 Matrices d'élasticité anisotropes non programmées
"""),

    38 : _(u"""
 Données incohérentes pour l'hydratation
 0<HYDR<1  0<HYDR_S<1 
"""),

    39 : _(u"""
 calcul de 1-DT non vérifié
"""),


    83 : _(u"""
 Vous utilisez le modèle BETON_UMLV avec un modèle d'endommagement.
 La mise à jour des contraintes sera faite suivant les déformations totales et non pas suivant un schéma incrémental.
"""),

    91 : _(u"""
   La loi métallurgique META_LEMA_ANI n'est utilisable qu'avec le zirconium.
"""),
}
