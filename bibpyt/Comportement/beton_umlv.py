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
    nom            = 'BETON_UMLV',
    doc            =   """Comportement de fluage propre du béton
   avec distinction fluage volumique et fluage déviatorique (R7.01.16)"""      ,
    num_lc         = 21,
    nb_vari        = 21,
    nom_vari       = ('ERSP','EISP','ERD11','EID11','ERD22',
        'EID22','ERD33','EID33','EFD11','EFD22',
        'EFD33','ERD12','EID12','ERD23','EID23',
        'ERD31','EID31','EFD12','EFD23','EFD31',
        'ISPH',),
    mc_mater       = ('ELAS','BETON_UMLV',),
    modelisation   = ('3D','AXIS','D_PLAN',),
    deformation    = ('PETIT','PETIT_REAC','GROT_GDEP',),
    algo_inte      = ('ANALYTIQUE',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('No',),
)
