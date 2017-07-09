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

# person_in_charge: mickael.abbas at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'CRIT_RUPT',
    doc            =   """Détection critère de rupture"""          ,
    num_lc         = 0,
    nb_vari        = 6,
    nom_vari       = ('EPSPVIT','EDISS','EDISSCUM','PDISS','PDISSCUM',
        'CRITRUPT',),
    mc_mater       = None,
    modelisation   = None,
    deformation    = None,
    algo_inte      = None,
    type_matr_tang = None,
    proprietes     = None,
    syme_matr_tang = ('Yes',),
    exte_vari      = None,
)
