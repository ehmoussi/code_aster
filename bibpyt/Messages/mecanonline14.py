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

# For DEBUG (INFO=2)

from code_aster.Utilities import _

cata_msg = {

     1 : _("""  Activation de la méthode IMPLEX."""),

     2 : _("""  Activation du calcul en dynamique explicite."""),

     3 : _("""  Activation de la méthode NEWTON_KRYLOV."""),

     4 : _("""  Activation de la méthode de réduction de modèle."""),

     5 : _("""  Activation de la méthode d'hyper réduction de modèle."""),

     6 : _("""  Activation de la méthode d'hyper réduction de modèle avec correction éléments finis."""),

     7 : _("""  Activation de la recherche linéaire."""),

     8 : _("""  Activation du pilotage."""),

     9 : _("""  Activation de la méthode de DEBORST."""),

    10 : _("""  Activation de la méthode par sous-structuration dynamique."""),

    11 : _("""  Activation de la méthode par projection modale."""),

    12 : _("""  Activation du contact."""),

    13 : _("""  Activation du contact discret."""),

    14 : _("""  Activation du contact continu."""),

    15 : _("""  Activation du contact XFEM."""),

    16 : _("""  Activation du contact XFEM avec THM."""),

    17 : _("""  Activation du contact LAC."""),

    18 : _("""  Activation du contact avec boucle de point fixe pour la géométrie."""),

    19 : _("""  Activation du contact avec boucle de point fixe pour les statuts de contact."""),

    20 : _("""  Activation du contact avec boucle de point fixe pour le frottement."""),

    21 : _("""  Activation du contact avec au moins une boucle de point fixe."""),

    22 : _("""  Activation du contact avec Newton pour la géométrie."""),

    23 : _("""  Activation du contact avec Newton pour le frottement."""),

    24 : _("""  Activation du contact avec Newton pour les statuts de contact."""),

    25 : _("""  Activation du contact sans calcul."""),

    26 : _("""  Activation du contact avec les zones initialement en contact."""),

    27 : _("""  Activation de liaisons unilatérales."""),

    28 : _("""  Activation du frottement discret."""),

    29 : _("""  Activation du frottement continu."""),

    30 : _("""  Activation du frottement XFEM."""),

    31 : _("""  Activation d'éléments de contact."""),

    32 : _("""  Activation des éléments HHO."""),

    33 : _("""  Activation d'éléments de type DIS_CHOC."""),

    34 : _("""  Activation d'éléments de structure en grandes rotations."""),

    35 : _("""  Activation d'éléments de type XFEM."""),

    36 : _("""  Activation d'éléments de structure de type PMF."""),

    37 : _("""  Activation du critère de convergence RESI_REFE_RELA."""),

    38 : _("""  Activation du critère de convergence RESI_COMP_RELA."""),

    39 : _("""  Activation de chargements suiveurs de type forces imposées."""),

    40 : _("""  Activation de chargements suiveurs de Dirichlet."""),

    41 : _("""  Activation de chargements de Dirichlet différentiels."""),

    42 : _("""  Activation de chargements de Dirichlet imposés par élimination."""),

    43 : _("""  Activation de chargements de Laplace."""),

    44 : _("""  Activation de macro-éléments."""),

    45 : _("""  Activation d'éléments de type THM."""),

    46 : _("""  Activation d'éléments de type GVNO."""),

    47 : _("""  Activation du calcul des modes de flambement."""),

    48 : _("""  Activation du calcul des modes de stabilité."""),

    49 : _("""  Activation du calcul des modes vibratoires."""),

    50 : _("""  Activation du calcul du bilan d'énergie."""),

    51 : _("""  Activation du calcul de l'indicateur d'erreur en temps pour la THM."""),

    52 : _("""  Activation du post-traitement pour le comportement."""),

    53 : _("""  Activation des variables de commande."""),

    54 : _("""  Activation des paramètres élastiques fonction des variables de commande."""),

    55 : _("""  Activation d'un concept enrichi."""),

    56 : _("""  Activation d'un état initial défini."""),

    57 : _("""  Activation du solveur LDLT."""),

    58 : _("""  Activation du solveur MULT_FRONT."""),

    59 : _("""  Activation du solveur GCPC."""),

    60 : _("""  Activation du solveur MUMPS."""),

    61 : _("""  Activation du solveur PETSC."""),

    62 : _("""  Activation du préconditionneur LDLT_SP."""),

    63 : _("""  Activation de la matrice distribuée."""),

    64 : _("""  Activation de contact par pénalisation."""),

    99 : _("""Création des structures de données."""),
}
