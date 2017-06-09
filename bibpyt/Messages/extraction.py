# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

    1 : _(u"""
Le champ de nom %(k1)s n'est pas présent.
Vous demandez certainement un champ qui n'est pas créé pour le type de 
calcul effectué. 
"""),

    3 : _(u"""
Le champ %(k1)s que l'on veut extraire est de type champ aux noeuds.
Vous n'avez pas précisé correctement son lieu d'extraction ou les noeuds donnés n'appartiennent pas au modèle.
"""),

    4 : _(u"""
Le champ %(k1)s que l'on veut extraire est de type champ aux points d'intégration.
Vous n'avez pas précisé correctement son lieu d'extraction ou les mailles données n'appartiennent pas au modèle.
"""),

    5 : _(u"""
Vous n'avez pas précisé le type de l'extraction pour le champ %(k1)s.
On a pris <VALE> par défaut.
"""),

    6 : _(u"""
Le champ %(k1)s que l'on veut extraire est de type champ aux points d'intégration.
Vous n'avez pas précisé le type de l'extraction.
On a pris <VALE> par défaut.
"""),

    7 : _(u"""
Le champ %(k1)s est de type <ELGA> et vous voulez extraire sa valeur (EXTR_ELGA='VALE').
Vous n'avez pas précisé l'endroit où il est doit être extrait.
Il faut donner le point d'intégration et le SOUS_POINT si c'est un élément de structure (POINT/SOUS_POINT).
"""),

    12 : _(u"""
 L'extraction doit se faire sur plus d'une composante et moins de %(i1)d composantes, or vous en avez %(i2)d.
"""),

    20 : _(u"""
 La composante %(k2)s est inconnue sur le noeud %(k1)s .
"""),

    21 : _(u"""
 La composante %(k2)s sur la maille %(k1)s sur le point d'intégration %(i1)d et le SOUS_POINT %(i2)d n'existe pas.
"""),

    22 : _(u"""
 La variable interne nommée %(k1)s n'existe pas sur les mailles concernées.
"""),

    24 : _(u"""
Erreur utilisateur commande RECU_TABLE / RESU :
  On veut désigner des variables internes en utilisant le mot clé NOM_VARI.
  Le mot clé RESU / RESULTAT est obligatoire. 
"""),

    25 : _(u"""
Erreur utilisateur commande RECU_TABLE / RESU :
  On veut désigner des variables internes en utilisant le mot clé NOM_VARI.
  Le champ concerné doit être un champ par élément de VARI_R.
  Ici, NOM_CHAM = %(k1)s 
"""),


    99: _(u"""
 Le champ %(k1)s que l'on veut extraire est incompatible avec la commande ou les fonctionnalités actives.
 On l'ignore.
"""),

}
