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
 Produit scalaire presque nul dans b3d_jacob2, entre les vecteurs :
                %(r1)f
                %(r2)f
            et
                %(r3)f
                %(r4)f
"""),

    12 : _(u"""
 Erreur lors de la diagonalisation de la matrice dans b3d_valp33 :
                %(r1)f, %(r2)f, %(r3)f
                %(r4)f, %(r5)f, %(r6)f
                %(r7)f, %(r8)f, %(r9)f
"""),

    13 : _(u"""
 Norme nulle ds b3d_vectp, matrice à diagonaliser :
                %(r1)f, %(r2)f, %(r3)f
                %(r4)f, %(r5)f, %(r6)f
                %(r7)f, %(r8)f, %(r9)f
"""),

    14 : _(u"""
 MVGN ne devrait pas etre nul pour bwpw
 mise a zero de la pression capillaire dans bwpw
"""),

    15 : _(u"""
 Attention srw= %(r1)f ds bwpw3d
"""),

    16 : _(u"""
 Probleme de dimension des variables internes dans cfluage3d, %(i1)d != %(i2)d
"""),

    17 : _(u"""
 Cas de pression intraporeuse imprevue dans criter3d :
                bgpg = %(r1)f
                bwpw = %(r2)f
"""),

    18 : _(u"""
 Delta plus grand que la racine carrée de 3 : impossible dans criter3d 
"""),

    19 : _(u"""
 DP atteignable par traction triaxiale ds criter3d
 Augmenter Rc ou diminuer Rt eff  (ou ept=rteff/E)
                rt = %(r1)f
                rc = %(r2)f
                rc min nec = %(r3)f
"""),

    20 : _(u"""
 Sous itération radiale désactivée
 controler direction ecoulement dans criter3d
"""),

    21 : _(u"""
 tau< taulim/1000 ds criter3d
 Atteinte du criter DP sans cisaillement
                valeur reelle = %(r1)f
                valeur adoptee = %(r2)f
"""),

    22 : _(u"""
 critere Dp annule alors que %(r1)f >%(r2)f
"""),

    23 : _(u"""
 Dilatance excessive > %(r1)f
"""),


    25 : _(u"""
 Il est preferable que bg.Mg(%(r1)f) < %(r2)f
"""),

    26 : _(u"""
 Problème lors du tir visco elastique ds fluendo3d
"""),

    27 : _(u"""
 Nombre d'itération maximum atteint : 
            ipla = %(i1)d
"""),

    28 : _(u"""
 Fluendo3d : cas elasticite anisotrope
 Changement de base pour la loi de comportement non programmé
"""),

    29 : _(u"""
 Fluendo3d : cas elasticite anisotrope
 Changement de base resistances non programmé
"""),

    30 : _(u"""
  Fluendo3d : problème dans la résolution du retour radial
"""),

    31 : _(u"""
 Fluendo3d : nombre maximum de sous itération annulant mult plast < 0 atteint :
            ipla = %(i1)d
"""),

    32 : _(u"""
 Critere non prevu dans fluage3d
"""),

    33 : _(u"""
 Fluendo3d : nombre d'itération maximum %(i1)d atteint :
             compteur de sous iteration plastique = %(i1)d
             nombre d'itération multiplicateur < 0 = %(i1)d
             
 Essayé de réduire la vitesse de chargement ou augmenter imax dans fluage3d

"""),

    34 : _(u"""
 Fluendo3d : erreur dans endo3d
"""),

    35 : _(u"""
 Taille du problème trop grand dans sellier gauss_3d :
            n = %(i1)d
            ngf = %(i1)d
"""),

    36 : _(u"""
 Fluendo3d : pivot nul dans gauss_3d :
            pivot maxi = %(r1)f
            ligne = %(i1)d
"""),

    37 : _(u"""
 Hydramat3d : matrices d'élasticité anisotropes non programmés
"""),

    38 : _(u"""
 Données incohérentes pour l hydratation
 0<HYDR<1  0<HYDRS<1 i.e. hydra3d.eso
"""),

    39 : _(u"""
 calcul de 1-Dt dans umdt3 non vérifié
"""),


    83 : _(u"""
 Vous utilisez le modèle BETON_UMLV avec un modèle d'endommagement.
 La mise à jour des contraintes sera faite suivant les déformations totales et non pas suivant un schéma incrémental.
"""),

    91 : _(u"""
   La loi métallurgique META_LEMA_ANI n'est utilisable qu'avec le zirconium.
"""),
}
