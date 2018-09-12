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

# person_in_charge: mickael.abbas at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'ELAS_MEMBRANE_SV',
    lc_type        = ('MECANIQUE',),
    doc            =   """Relation de comportement hyper-élastique utilisant le modèle de Saint-Venant Kirchhoff
           applicable uniquement aux MEMBRANE en grandes déformations (DEFORMATION='GROT_GDEP') """              ,
    num_lc         = 0,
    nb_vari        = 1,
    nom_vari       = ('VIDE',),
    mc_mater       = ('ELAS',),
    modelisation   = ('C_PLAN',),
    deformation    = ('GROT_GDEP',),
    algo_inte      = ('ANALYTIQUE',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = ('COMP_ELAS',),
    syme_matr_tang = ('Yes',),
    exte_vari      = None,
    deform_ldc     = ('OLD',),
)
