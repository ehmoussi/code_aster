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

# person_in_charge: marc.kham at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'MOHR_COULOMB',
    lc_type        = ('MECANIQUE',),
    doc            =   """Loi de Mohr_Coulomb, non-associée, pour la mécanique des sols (cf. [R7.01.16] pour plus de détails).
            Pas d'ecrouissage"""              ,
    num_lc         = 55,
    nb_vari        = 3,
    nom_vari       = ('EPSPVOL','EPSPEQ','INDIPLAS',),
    mc_mater       = ('ELAS','MOHR_COULOMB',),
    modelisation   = ('3D','AXIS','D_PLAN','C_PLAN',),
    deformation    = ('PETIT','PETIT_REAC','GROT_GDEP',),
    algo_inte      = ('ANALYTIQUE',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('No',),
    exte_vari      = None,
    deform_ldc     = ('OLD',),
)
