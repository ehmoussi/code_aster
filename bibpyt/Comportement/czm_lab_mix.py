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
    nom            = 'CZM_LAB_MIX',
    lc_type        = ('MECANIQUE',),
    doc            =   """Relation de comportement pour une liaison acier-béton, basée sur une formulation mixte (Cf. [R7.02.11])"""            ,
    num_lc         = 51,
    nb_vari        = 5,
    nom_vari       = ('SEUILDEP','INDIDISS','SAUT_N','SAUT_T1','SAUT_T2',
        ),
    mc_mater       = ('CZM_LAB_MIX',),
    modelisation   = ('3D','PLAN','AXIS','INTERFAC',),
    deformation    = ('PETIT',),
    algo_inte      = ('ANALYTIQUE',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('Yes',),
    exte_vari      = None,
)
