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

    2  : _("""Il ne peut y avoir qu'un seul matériau de type MFront dans DEFI_MATERIAU."""),

    3  : _("""Propriétés définies dans le matériau: %(k1)s.
"""),

    4  : _("""Paramètres des propriétés %(k1)s:"""),

    11 : _("""
 Erreur d'utilisation lors de l'affectation des variables de commande (AFFE_MATERIAU/AFFE_VARC):
   Pour la variable de commande %(k1)s,
   Vous avez oublié d'utiliser l'un des 2 mots clés CHAM_GD ou EVOL.
   L'absence de ces deux mots clés n'est permise que pour NOM_VARC='TEMP'.
"""),

    9  : _("""
Pour le matériau %(k1)s, on cherche à redéfinir un mot clé déjà défini : %(k2)s
L'utilisation de DEFI_MATERIAU en mode enrichissement ne permet que d'ajouter de nouvelles données.
"""),

   10 : _("""
Vérification de la positivité de la matrice d'élasticité. Il faut renseigner le coefficient E_N dans les cas des déformations planes et de l'axisymétrie.
On ne regarde donc que le cas des contraintes planes.
"""),


    13 : _("""
 Erreur d'utilisation (AFFE_MATERIAU/AFFE_VARC) :
  Le maillage associé au calcul (%(k1)s) est différent de celui associé
  aux champs (ou EVOL_XXXX) affectés dans AFFE_MATERIAU/AFFE_VARC (%(k2)s).

 Conseil :
  Il faut corriger AFFE_MATERIAU.
"""),

    20 : _("""
 La matrice d'élasticité orthotrope ou isotrope transverse est non définie positive
  (au moins une valeur propre négative). Si vous êtes sur une modélisation
  isoparamétrique (pas d'éléments de structure), vous avez probablement fait une erreur.

 Conseil :
  Vérifiez vos données matériau.
"""),

    50 : _("""
Erreur utilisateur dans la commande AFFE_MATERIAU / AFFE_VARC
  Pour la variable de commande %(k1)s
  la grandeur associée du champ doit être:  %(k2)s  mais elle est:  %(k3)s
"""),

    51 : _("""
 Vous utilisez la variable de commande de température alors que votre problème est couplé.
 Ce n'est pas possible.
"""),

}
