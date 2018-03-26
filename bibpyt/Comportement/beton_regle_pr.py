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


from cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'BETON_REGLE_PR',
    lc_type        = ('MECANIQUE',),
    doc            =   """Relation de comportement de béton (développée par la société NECS) dite 'parabole rectangle' [R7.01.27].
   La loi BETON_REGLE_PR est une loi de béton se rapprochant des lois réglementaires de béton (d'où son nom)
   qui a les caractéristiques sommaires suivantes :
-c'est une loi 2D et plus exactement 2 fois 1D : dans le repère propre de déformation, on écrit une loi 1D contrainte-déformation ;
-la loi 1D sur chaque direction de déformation propre est la suivante :
* en traction, linéaire jusqu'à un pic, adoucissement linéaire jusqu'à 0 ;
* en compression, une loi puissance jusqu'à un plateau (d'ou PR : parabole-rectangle)."""              ,
    num_lc         = 9,
    nb_vari        = 1,
    nom_vari       = ('EPSPEQ',),
    mc_mater       = ('ELAS','BETON_REGLE_PR',),
    modelisation   = ('D_PLAN','C_PLAN',),
    deformation    = ('PETIT','PETIT_REAC','GROT_GDEP',),
    algo_inte      = ('ANALYTIQUE',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('Yes',),
    exte_vari      = None,
    deform_ldc     = ('OLD',),
)
