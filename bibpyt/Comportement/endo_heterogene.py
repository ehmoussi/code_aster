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
    nom            = 'ENDO_HETEROGENE',
    doc            =   """Comportement élastique-heterogene, à endommagement  - R5.03.24"""      ,
    num_lc         = 47,
    nb_vari        = 12,
    nom_vari       = ('ENDO','INDIENDO','ALEA','SURF','ELEP1',
        'ELEP2','COMR','COMPT','X1','Y1',
        'X2','Y2',),
    mc_mater       = ('ELAS','ENDO_HETEROGENE','NON_LOCAL',),
    modelisation   = ('D_PLAN','GRADSIGM',),
    deformation    = ('PETIT','PETIT_REAC',),
    algo_inte      = ('ANALYTIQUE',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('Yes',),
)
