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

# person_in_charge: etienne.grimal at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'FLUA_PORO_BETON',
    lc_type        = ('MECANIQUE',),
    doc            =   """Loi Fluage pour le beton"""            ,
    num_lc         = 165,
    nb_vari        = 77,
    nom_vari       = ('HYD0','SSG1','SSG2','SSG3','SSG4',
        'SSG5','SSG6','EPG1','EPG2','EPG3',
        'EPG4','EPG5','EPG6','DG1','DG2',
        'DG3','PWAT','PGEL','SSW1','SSW2',
        'SSW3','SSW4','SSW5','SSW6','DW1',
        'DW2','DW3','DTH','PAS0','E0S',
        'E1S','E2S','VE1S','VE2S','E0D1',
        'E1D1','E2D1','VE11','VE21','E0D2',
        'E1D2','E2D2','VE12','VE22','E0D3',
        'E1D3','E2D3','VE13','VE23','E0D4',
        'E1D4','E2D4','VE14','VE24','E0D5',
        'E1D5','E2D5','VE15','VE25','E0D6',
        'E1D6','E2D6','VE16','VE26','TMP1',
        'MSRF','SET1','SET2','SET3','SET4',
        'SET5','SET6','PHIS','PHID','EPEQ',
        'DFLU','CCF1',),
    mc_mater       = ('ELAS','FLUA3D',),
    modelisation   = ('3D',),
    deformation    = ('PETIT','PETIT_REAC',),
    algo_inte      = ('SPECIFIQUE',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('Yes',),
    exte_vari      = None,
)
