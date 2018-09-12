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

# person_in_charge: jean-luc.flejou at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'CABLE',
    lc_type        = ('MECANIQUE',),
    doc            =   """Relation de comportement élastique adaptée aux câbles (DEFORMATION: 'GREEN' obligatoire) :
   le module d'YOUNG du câble peut être différent en compression et en traction (en particulier il peut être nul en compression)."""              ,
    num_lc         = 0,
    nb_vari        = 1,
    nom_vari       = ('VIDE',),
    mc_mater       = ('ELAS',),
    modelisation   = ('CABLE',),
    deformation    = ('GROT_GDEP',),
    algo_inte      = ('ANALYTIQUE',),
    type_matr_tang = None,
    proprietes     = ('COMP_ELAS',),
    syme_matr_tang = ('Yes',),
    exte_vari      = None,
    deform_ldc     = ('OLD',),
)
