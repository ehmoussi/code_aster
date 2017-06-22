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

# person_in_charge: sofiane.hendili at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'META_V_IL_PT',
    doc            =   """Loi de comportement elasto-visco-plastique à écrouissage isotrope linéaire,
   prenant en compte la métallurgie, la plasticité de transformation,"""      ,
    num_lc         = 15,
    nb_vari        = 1,
    nom_vari       = ('EPSPEQ',),
    mc_mater       = ('ELAS_META','META_VISC','META_ECRO_LINE','META_PT',),
    modelisation   = ('3D','AXIS','D_PLAN',),
    deformation    = ('PETIT','PETIT_REAC','GROT_GDEP','SIMO_MIEHE',),
    algo_inte      = ('SPECIFIQUE',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('Yes',),
)
