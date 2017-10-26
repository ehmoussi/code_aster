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
    nom            = 'MAZARS',
    lc_type        = ('MECANIQUE',),
    doc            =   """Loi d'endommagement isotrope élastique-fragile du béton, suivant le modèle de Mazars.
   Elle permet de prendre en comtpe l'adoucissement et distingue l'endommagemetn en traction et en compression.
   Une seule variable d'endommagement scalaire est utilisée (cf [R7.01.08]).
   En cas de chargement thermique, les coefficients matériau dépendent de la température maximale atteinte au point de Gauss considéré,
   et la dilatation thermique, supposée linéaire, ne contribue pas à l'évolution de l'endommagement."""            ,
    num_lc         = 8,
    nb_vari        = 4,
    nom_vari       = ('ENDO','INDIENDO','TEMP_MAX','EPSEQ',),
    mc_mater       = ('ELAS','MAZARS','NON_LOCAL',),
    modelisation   = ('3D','AXIS','C_PLAN','D_PLAN','GRADEPSI',
        ),
    deformation    = ('PETIT','PETIT_REAC','GROT_GDEP',),
    algo_inte      = ('ANALYTIQUE',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('No',),
    exte_vari      = None,
)
