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


cata_msg = {


    7 : _(u"""
 Il n'est pas possible d'utiliser les repères 'UTILISATEUR' et
 'CYLINDRIQUE' quand TYPE_CHAM vaut 'TENS_2D' ou 'TENS_3D' ou 'TORS_3D' et
 que le modèle contient des éléments plaques ou coques.
"""),

    9 : _(u"""
 Vous avez choisie une méthode à pas de temps adaptatif. Il n'est pas possible de prendre en compte une
 liste d'instants de calcul définie a priori.
"""),

    10 : _(u"""
  -> Contact avec DYNA_VIBRA : Il y a interpénétration d'une valeur supérieure à (DIST_MAIT + DIST_ESCL).
  -> Risque & Conseil :
     DIST_MAIT et DIST_ESCL permettent de tenir compte d'une épaisseur de matériau non représentée dans le maillage
     (rayon d'une poutre, épaisseur d'une coque ou simplement une bosse). Une trop forte interpénétration peut venir
     d'une erreur dans le fichier de commande : RIGI_NOR trop faible ; noeuds de contact qui ne sont en vis à vis ;
     OBSTACLE et NORM_OBSTACLE incohérents. Dans le cas de deux poutres aux fibres neutres confondues, elle peut
     générer des erreurs dans l'orientation des forces de contact.
"""),











    18 : _(u"""
 La liste des instants de calcul ne doit contenir qu'un seul pas
 Conseil: si vous avez défini une liste d'instants manuellement par des valeurs discrètes,
 veillez à ce que le pas soit constant dans tout l'intervalle.
"""),








    36 : _(u"""
 NUME_INIT: on n'a pas trouvé le NUME_INIT dans le résultat  %(k1)s
"""),

    37 : _(u"""
 incohérence sur H, ALPHA, ELAS
"""),

    38 : _(u"""
 L'état de contrainte fourni n'est pas cohérent avec le modèle de comportement de DRUCK_PRAGER.
 Vérifier les champs SIEF_ELGA et VARI_ELGA dans ETAT_INIT.
"""),

    40 : _(u"""
 le NOM_CHAM  %(k1)s n'appartient pas à la structure de données
"""),

    41 : _(u"""
 erreur(s) dans les données
"""),

    43 : _(u"""
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    55 : _(u"""
 ITER_INTE_MAXI insuffisant
"""),

    60 : _(u"""
 la matrice interspectrale possède un pivot nul.
"""),








    78 : _(u"""
 pas de discrétisation de l'interspectre non constant.
"""),

    80 : _(u"""
 "NB_POIN" n est pas une puissance de 2
 on prend la puissance de 2 supérieure
"""),

    83 : _(u"""
 le pas tend vers 0 ...
"""),

    86 : _(u"""
 pas d'interpolation possible pour les fréquences.
"""),

    87 : _(u"""
 dérivée de F nulle
"""),

    88 : _(u"""
 GM négatif
"""),

    89 : _(u"""
 valeurs propres non ordonnées :
 %(k1)s  %(k2)s  %(k3)s
"""),

    90 : _(u"""
 coefficients paraboliques pas compatibles
"""),

    92 : _(u"""
 modélisations C_PLAN et 1D pas autorisées
"""),








}
