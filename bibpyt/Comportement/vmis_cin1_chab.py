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

from cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'VMIS_CIN1_CHAB',
    doc            =   """Loi élastoplastique de J.L.Chaboche à 1 variable cinématique qui rend compte du comportement cyclique en élasto-plasticité
   avec un tenseur d'écrouissage cinématique non linéaire, un écrouissage isotrope non linéaire, un effet d'écrouissage sur la variable
   tensorielle de rappel. Toutes les constantes du matériau peuvent éventuellement dépendre de la température."""      ,
    num_lc         = 4,
    nb_vari        = 8,
    nom_vari       = ('EPSPEQ','INDIPLAS','ALPHAXX','ALPHAYY','ALPHAZZ',
        'ALPHAXY','ALPHAXZ','ALPHAYZ',),
    mc_mater       = ('ELAS','CIN1_CHAB',),
    modelisation   = ('3D','AXIS','D_PLAN',),
    deformation    = ('PETIT','PETIT_REAC','GROT_GDEP','GDEF_LOG',),
    algo_inte      = ('SECANTE','BRENT',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('Yes',),
)
