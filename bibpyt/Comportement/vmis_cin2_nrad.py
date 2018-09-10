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
    nom            = 'VMIS_CIN2_NRAD',
    lc_type        = ('MECANIQUE',),
    doc            =   """Loi élastoplastique de J.L.Chaboche à 2 variables cinématiques qui rend compte du comportement cyclique en élasto-plasticité
   avec 2 tenseurs d'écrouissage cinématique non linéaire, un écrouissage isotrope non linéaire, un effet d'écrouissage sur les variables
   tensorielles de rappel, et prise en compte de la non proportionnalité du chargement.
   Toutes les constantes du matériau peuvent éventuellement dépendre de la température."""              ,
    num_lc         = 4,
    nb_vari        = 14,
    nom_vari       = ('EPSPEQ','INDIPLAS','ALPHAXX','ALPHAYY','ALPHAZZ',
        'ALPHAXY','ALPHAXZ','ALPHAYZ','ALPHA2XX','ALPHA2YY',
        'ALPHA2ZZ','ALPHA2XY','ALPHA2XZ','ALPHA2YZ',),
    mc_mater       = ('ELAS','CIN2_CHAB','CIN2_NRAD',),
    modelisation   = ('3D','AXIS','D_PLAN',),
    deformation    = ('PETIT','PETIT_REAC','GROT_GDEP','GDEF_LOG',),
    algo_inte      = ('BRENT','SECANTE',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('Yes',),
    exte_vari      = None,
    deform_ldc     = ('OLD',),
)
