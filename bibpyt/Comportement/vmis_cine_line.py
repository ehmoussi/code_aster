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
    nom            = 'VMIS_CINE_LINE',
    lc_type        = ('MECANIQUE',),
    doc            =   """Loi de Von Mises - Prager avec ecrouissage cinematique lineaire [R5.03.02]"""              ,
    num_lc         = 3,
    nb_vari        = 7,
    nom_vari       = ('XCINXX','XCINYY','XCINZZ','XCINXY','XCINXZ',
        'XCINYZ','INDIPLAS',),
    mc_mater       = ('ELAS','ECRO_LINE',),
    modelisation   = ('3D','AXIS','D_PLAN','1D',),
    deformation    = ('PETIT','PETIT_REAC','GROT_GDEP','GDEF_LOG',),
    algo_inte      = ('ANALYTIQUE',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('Yes',),
    exte_vari      = None,
    deform_ldc     = ('OLD',),
)
