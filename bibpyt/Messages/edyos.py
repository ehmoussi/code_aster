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


#
#  messages d'erreur pour interface Aster/edyos
#
#
#    Ce script python permet d'associer un texte aux numéros d'erreur
#    appelés dans le sous programme errcou.f
#    Ces messages d'erreur sont issus de la note HI-26/03/007A
#    "DEVELOPPEMENT D'UN MODE PRODUCTION POUR CALCIUM: MANUEL UTILISATEUR"
#    ANNEXE 1: CODES D'ERREURS  (PAGE 70)
#    FAYOLLE ERIC, DEMKO BERTRAND (CS SI)  JUILLET 2003
#
#    Les numéros des erreurs de ce script correspondent aux numéros de la
#    référence bibliographique
from code_aster.Utilities import _

cata_msg = {

    1 : _("""
      YACS : Émetteur inconnu
"""),

    2 : _("""
      YACS : Nom de variable inconnu
"""),

    3 : _("""
      YACS : Variable ne devant pas être lue mais écrite
"""),


    4 : _("""
      YACS : Type de variable inconnu
"""),

    5 : _("""
      YACS : Type de variable différent de celui déclaré
"""),

    6 : _("""
      YACS : Mode de dépendance inconnu
"""),

    7 : _("""
      YACS : Mode de dépendance différent de celui déclaré
"""),

    8 : _("""
      YACS : Requête non autorisée
"""),

    9 : _("""
      YACS : Type de déconnexion incorrect
"""),

    10 : _("""
       YACS : Directive de déconnexion incorrecte
"""),

    11 : _("""
       YACS : Nom de code inconnu
"""),

    12 : _("""
       YACS : Nom d'instance inconnue
"""),

    13 : _("""
      YACS : Requête en attente
"""),

    14 : _("""
      YACS : Message de service
"""),

    15 : _("""
      YACS : Nombre de valeurs transmises nul
"""),

    16 : _("""
       YACS : Dimension de tableau récepteur insuffisante
"""),

    17 : _("""
      YACS : Blocage
"""),

    18 : _("""
      YACS : Arrêt anormal d'une instance
"""),

    19 : _("""
      YACS : Coupleur absent...
"""),

    20 : _("""
      YACS : Variable ne figurant dans aucun lien
"""),

    21 : _("""
      YACS : Nombre de pas de calcul égal à zéro
"""),

    22 : _("""
      YACS : Machine non déclarée
"""),

    23 : _("""
      YACS : Erreur variable d'environnement COUPLAGE_GROUPE non positionnée
"""),

    24 : _("""
=      YACS : Variable d'environnement COUPLAGE_GROUPE inconnue
"""),

    25 : _("""
      YACS : Valeur d'information non utilisée
"""),

    26 : _("""
      YACS : Erreur de format dans le fichier de couplage
"""),

    27 : _("""
      YACS : Requête annulée à cause du passage en mode normal
"""),

    28 : _("""
      YACS : Coupleur en mode d'exécution normal
"""),

    29 : _("""
      YACS : Option inconnue
"""),

    30 : _("""
      YACS : Valeur d'option incorrecte
"""),

    31 : _("""
      YACS : Écriture d'une variable dont l'effacement est demandé
"""),

    32 : _("""
      YACS : Lecture d'une variable incorrectement connectée
"""),

    33 : _("""
      YACS : Valeur d'information non utilisée
"""),

    34 : _("""
      YACS : Valeur d'information non utilisée
"""),

    35 : _("""
      YACS : Erreur dans la chaîne de déclaration
"""),

    36 : _("""
      YACS : Erreur dans le lancement dynamique d'une instance
"""),

    37 : _("""
      YACS : Erreur de communication
"""),

    38 : _("""
      YACS : Valeur d'information non utilisée
"""),

    39 : _("""
      YACS : Mode d'exécution non défini
"""),

    40 : _("""
      YACS : Instance déconnectée
"""),


    41 : _("""
 Avertissement YACS (gravité faible) :
       Dans le SSP %(k1)s la variable %(k2)s a une valeur différente
       de celle envoyée
"""),

    42 : _("""
 Erreur YACS :
       Problème dans le SSP  : %(k1)s
       Pour la variable      : %(k2)s
       A l'itération numéro  : %(i1)d
"""),

    43 : _("""
      Attention, le nombre maximal de palier est 20
"""),

    45 : _("""
      Non convergence du code EDYOS
"""),

    49 : _("""
      Erreur de syntaxe pour le couplage avec EDYOS :
      Pour le mot-clé PALIERS_EDYOS dans le cas où l'on utilise TYPE_EDYOS,
      il faut donner à chaque occurrence soit le GROUP_NO du palier, soit son NOEUD.

"""),

}
