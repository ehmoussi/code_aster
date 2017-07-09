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

# person_in_charge: samuel.geniaut at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'BETON_DOUBLE_DP',
    doc            =   """Relation de comportement tridimensionnelle utilisée pour la description du comportement non linéaire du béton.
   Il comporte un critere de Drucker-Prager en traction et un critère de Drucker-Prager en compression, découplés.
   Les deux critères peuvent avoir un écrouissage adoucissant."""          ,
    num_lc         = 120,
    nb_vari        = 4,
    nom_vari       = ('EPSPEQT','EPSPEQC','TEMP_MAX','INDIPLAS',),
    mc_mater       = ('ELAS','BETON_DOUBLE_DP',),
    modelisation   = ('3D','AXIS','D_PLAN',),
    deformation    = ('PETIT','PETIT_REAC','GROT_GDEP',),
    algo_inte      = ('NEWTON',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('Yes',),
    exte_vari      = ('ELTSIZE1',),
)
