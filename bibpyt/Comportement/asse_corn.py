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
    nom            = 'ASSE_CORN',
    doc            =   """Relation de comportement élasto-plastique isotherme pour les assemblages boulonnés de cornières de pylônes [R5.03.32]"""      ,
    num_lc         = 0,
    nb_vari        = 7,
    nom_vari       = ('ASSCORN1','ASSCORN2','ASSCORN3','ASSCORN4','ASSCORN5',
        'ASSCORN6','ASSCORN7',),
    mc_mater       = ('ASSE_CORN',),
    modelisation   = ('DIS_TR','DIS_T',),
    deformation    = ('PETIT','PETIT_REAC','GROT_GDEP',),
    algo_inte      = ('ANALYTIQUE',),
    type_matr_tang = None,
    proprietes     = None,
    syme_matr_tang = ('Yes',),
)
