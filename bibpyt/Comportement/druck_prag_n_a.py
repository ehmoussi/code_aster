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

# person_in_charge: sam.cuvilliez at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'DRUCK_PRAG_N_A',
    doc            =   """Loi de Drucker_Prager, non associée, pour la mécanique des sols (cf. [R7.01.16] pour plus de détails).
   On suppose toutefois que le coefficient de dilatation thermique est constant. L'écrouissage peut être linéaire ou parabolique."""      ,
    num_lc         = 16,
    nb_vari        = 3,
    nom_vari       = ('EPSPEQ','EPSPVOL','INDIPLAS',),
    mc_mater       = ('ELAS','DRUCKER_PRAGER',),
    modelisation   = ('3D','AXIS','D_PLAN','GRADEPSI',),
    deformation    = ('PETIT','PETIT_REAC','GROT_GDEP',),
    algo_inte      = ('ANALYTIQUE',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('No',),
)
