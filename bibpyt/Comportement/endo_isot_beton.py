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

# person_in_charge: sylvie.michel-ponnelle at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'ENDO_ISOT_BETON',
    doc            =   """Comportement élastique-fragile qui distingue traction et compression du bétonRelation de comportement élastique fragile.
   Il s'agit d'une modélisation locale à endommagement scalaire et à écrouissage isotrope linéaire négatif qui distingue le comportement
   en traction et en compression du béton (Cf. [R7.01.04] pour plus de détails)."""          ,
    num_lc         = 36,
    nb_vari        = 2,
    nom_vari       = ('ENDO','INDIENDO',),
    mc_mater       = ('ELAS','BETON_ECRO_LINE','NON_LOCAL',),
    modelisation   = ('3D','AXIS','D_PLAN','GRADVARI','GRADEPSI',
        ),
    deformation    = ('PETIT','PETIT_REAC','GROT_GDEP',),
    algo_inte      = ('ANALYTIQUE',),
    type_matr_tang = ('PERTURBATION','VERIFICATION','IMPLEX',),
    proprietes     = None,
    syme_matr_tang = ('Yes',),
    exte_vari      = None,
)
