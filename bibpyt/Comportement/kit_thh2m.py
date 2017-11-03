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
    nom            = 'KIT_THH2M',
    lc_type        = ('KIT_THM',),
    doc            =   """KIT associé au comportement des milieux poreux (modélisations thermo-hydro-mécanique).
   Pour plus de détails sur les modélisations thermo-hydro-mécaniques et les modèles de comportement,
   """            ,
    num_lc         = 0,
    nb_vari        = 0,
    nom_vari       = None,
    mc_mater       = None,
    modelisation   = ('D_PLAN_THH2MD','AXIS_THH2MD','3D_THH2MD','D_PLAN_THH2MS','AXIS_THH2MS',
        '3D_THH2MS',),
    deformation    = ('PETIT',),
    algo_inte      = ('SANS_OBJET',),
    type_matr_tang = None,
    proprietes     = None,
    syme_matr_tang = ('Yes',),
    exte_vari      = None,
)
