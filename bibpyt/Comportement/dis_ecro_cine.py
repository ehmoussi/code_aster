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

# person_in_charge: francois.voldoire at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'DIS_ECRO_CINE',
    lc_type        = ('MECANIQUE',),
    doc            =   """Relation de comportement à écrouissage cinématique des elements discrets"""            ,
    num_lc         = 0,
    nb_vari        = 18,
    nom_vari       = ('DIS1','DIS2','DIS3','DIS4','DIS5',
        'DIS6','DIS7','DIS8','DIS9','DIS10',
        'DIS11','DIS12','DIS13','DIS14','DIS15',
        'DIS16','DIS17','DIS18',),
    mc_mater       = None,
    modelisation   = ('DIS_T','DIS_TR','2D_DIS_T','2D_DIS_TR',),
    deformation    = ('PETIT','PETIT_REAC','GROT_GDEP',),
    algo_inte      = ('ANALYTIQUE',),
    type_matr_tang = None,
    proprietes     = None,
    syme_matr_tang = ('Yes',),
    exte_vari      = None,
)
