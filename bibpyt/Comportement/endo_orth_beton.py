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

# person_in_charge: sylvie.michel-ponnelle at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'ENDO_ORTH_BETON',
    lc_type        = ('MECANIQUE',),
    doc            =   """Relation de comportement anisotrope du béton avec endommagement [R7.01.09].
   Il s'agit d'une modélisation locale d'endommagement prenant en compte la refermeture des fissures."""            ,
    num_lc         = 7,
    nb_vari        = 7,
    nom_vari       = ('ENDOXX','ENDOYY','ENDOZZ','ENDOXY','ENDOXZ',
        'ENDOYZ','ENDOCOMP',),
    mc_mater       = ('ELAS','ENDO_ORTH_BETON','NON_LOCAL',),
    modelisation   = ('3D','AXIS','D_PLAN','GRADEPSI',),
    deformation    = ('PETIT','PETIT_REAC','GROT_GDEP',),
    algo_inte      = ('NEWTON',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('No',),
    exte_vari      = None,
)
