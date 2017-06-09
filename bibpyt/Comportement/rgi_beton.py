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
    nom            = 'RGI_BETON',
    doc            =   """lois associees aux reactions de gonglements internes (RAG et RSI) dans le beton"""      ,
    num_lc         = 167,
    nb_vari        = 26,
    nom_vari       = ('SEE1','SEE2','SEE3','SEE4','SEE5',
        'SEE6','HYD','CSH','ALL','ALF',
        'SULL','SULF','AFT','AFM','ID',
        'CASH','CSHE','TMDF','CAL','VDEF',
        'VTOT','ARAG','VRAG','NSOL','DTHE',
        'VWE',),
    mc_mater       = ('ELAS','RGILIN3D',),
    modelisation   = ('3D',),
    deformation    = ('PETIT','PETIT_REAC',),
    algo_inte      = ('SPECIFIQUE',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('Yes',),
)
