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

# person_in_charge: kyrylo.kazymyrenko at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'RUPT_FRAG',
    doc            =   """Relation de comportement non locale basée sur la formulation de J.J. Marigo et G. Francfort de la mécanique de la rupture (pas d'équivalent en version locale).
   Ce modèle décrit l'apparition et la propagation de fissures dans un matériau élastique (cf. [R7.02.11])."""      ,
    num_lc         = 0,
    nb_vari        = 1,
    nom_vari       = ('ENDO',),
    mc_mater       = ('ELAS','RUPT_FRAG','NON_LOCAL',),
    modelisation   = ('ELEMDISC','GRADVARI',),
    deformation    = ('PETIT',),
    algo_inte      = ('ANALYTIQUE',),
    type_matr_tang = None,
    proprietes     = None,
    syme_matr_tang = ('Yes',),
)
