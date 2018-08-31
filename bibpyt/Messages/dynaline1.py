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

    2 : _(u"""
La méthode de Newmark est programmée sous sa forme implicite: le paramètre BETA ne doit pas être nul.
 """),

    11 : _(u"""
Vous utilisez une méthode à pas adaptatif: la donnée du pas est obligatoire.
"""),

    12 : _(u"""
Vous utilisez une méthode à pas adaptatif: le pas de temps ne peut pas être nul.
"""),

    13 : _(u"""
Les matrices de masse élémentaires doivent obligatoirement avoir été  calculées avec l'option MASS_MECA_DIAG.
"""),

    16 : _(u"""
A l'instant %(r1)f, l'erreur vaut %(r2)f
Cette erreur est supérieure à un.
Le pas de temps vaut %(r3)f
On arrête de le réduire, car le nombre de réductions a atteint %(i1)d, qui est le maximum possible.
"""),

    17 : _(u"""
Vous utilisez une méthode à pas adaptatif: le pas de temps minimal a été atteint.
"""),

    20 : _(u"""
Un chargement de type Dirichlet non homogène nécessite la résolution par le schéma de NEWMARK.
"""),

    21 : _(u"""
Nombre de pas de calcul : %(i1)d
Nombre d'itérations     : %(i2)d
"""),

    22 : _(u"""
Il n'est pas possible de combiner les chargements CHARGE et VECT_ASSE sauf pour les ondes planes.
"""),

    23 : _(u"""
Vous calculez une impédance absorbante.
"""),

    24 : _(u"""
Avec les chargements sélectionnés, le modèle est obligatoire.
"""),

    25 : _(u"""
Le champ "DEPL" n'est pas trouvé dans le concept résultat de l'état initial.
"""),

    26 : _(u"""
Le champ "VITE" n'est pas trouvé dans le concept résultat de l'état initial.
"""),

    27 : _(u"""
Le champ "ACCE" n'est pas trouve dans le concept résultat de l'état initial.
"""),

    28 : _(u"""
La commande DYNA_VIBRA avec TYPE_CALCUL="HARM" utilise un concept ré-entrant : le concept dans le mot-clé "RESULTAT" doit avoir le même nom que la sortie.
"""),

    29 : _(u"""
La commande DYNA_VIBRA avec TYPE_CALCUL="HARM" utilise un concept ré-entrant : le concept dans le mot-clé "RESULTAT" est d'un type différent.
"""),

    31 : _(u"""
La commande DYNA_VIBRA avec TYPE_CALCUL="HARM" utilise un concept ré-entrant : le mot-clé "RESULTAT" est obligatoire.
"""),

    34 : _(u"""
Les matrices ne possèdent pas toutes la même numérotation.
"""),

    46 : _(u"""
 Il manque les modes statiques. Vérifiez que MODE_STAT est bien renseigné.
"""),

    89 : _(u"""
L'instant de reprise est supérieur au dernier instant dans la liste.
Instant de reprise :  %(r1)f
Dernier instant    :  %(r2)f
"""),

    90 : _(u"""
On n'a pas trouvé l'instant de reprise.
Instant de reprise:  %(r1)f
Pas de temps      :  %(r2)f
Borne min         :  %(r3)f
Borne max         :  %(r4)f
"""),

    91 : _(u"""
L'instant final est inférieur au premier instant dans la liste.
Instant final:  %(r1)f
Instant min  :  %(r2)f
"""),

    92 : _(u"""
On n'a pas trouvé l'instant dans la liste.
Instant final:  %(r1)f
Pas de temps :  %(r2)f
Borne min    :  %(r3)f
Borne max    :  %(r4)f
"""),

    95 : _(u"""
L'entrée d'amortissements réduits est incompatible avec le type de la matrice de rigidité.
Il faut des matrices de type MATR_ASSE_GENE.
"""),

    96 : _(u"""
Le nombre de coefficients d'amortissement réduit est trop grand.
Il y a %(i1)d modes propres et %(i2)d coefficients.
On ne garde donc que les  %(i3)d premiers coefficients.
"""),

    97 : _(u"""
Le nombre de coefficients d'amortissement réduit est trop petit, il en manque %(i1)d car il y a %(i2)d modes propres.
On rajoute  %(i3)d amortissements réduits avec la valeur de celui du dernier mode propre.
"""),

}
