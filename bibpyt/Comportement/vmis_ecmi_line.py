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
    nom            = 'VMIS_ECMI_LINE',
    doc            =   """Relation de comportement d'élasto-plasticité de VON MISES à écrouissage combiné,
   cinématique linéaire et isotrope linéaire (Cf. [R5.03.16] pour plus de détails)."""          ,
    num_lc         = 3,
    nb_vari        = 8,
    nom_vari       = ('EPSPEQ','INDIPLAS','XCINXX','XCINYY','XCINZZ',
        'XCINXY','XCINXZ','XCINYZ',),
    mc_mater       = ('ELAS','ECRO_LINE','PRAGER',),
    modelisation   = ('3D','AXIS','C_PLAN','D_PLAN',),
    deformation    = ('PETIT','PETIT_REAC','GROT_GDEP','GDEF_LOG',),
    algo_inte      = ('ANALYTIQUE',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('Yes',),
    exte_vari      = None,
)
