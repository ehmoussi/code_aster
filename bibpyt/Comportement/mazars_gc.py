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
    nom            = 'MAZARS_GC',
    doc            =   """
   Loi d'endommagement isotrope élastique-fragile du béton, suivant le modèle de Mazars.
   Permet de rendre compte de l'adoucissement en compression et la fragilité en traction.
   Dans le cas des poutres multifibres :
      Distingue l'endommagement en traction et en compression. Deux variables d'endommagement scalaire
      sont utilisées pour faire la distinction entre l'endommagement de traction et de compression.
   En contrainte plane :
      Pas de couplage possible avec d'autres phénomènes tels que le fluage.
      Cette version permet de rendre mieux compte du cisaillement.
   """      ,
    num_lc         = 8,
    nb_vari        = 8,
    nom_vari       = ('CRITSIG','CRITEPS','ENDO','EPSEQT','EPSEQC',
        'RSIGMA','TEMP_MAX','DISSIP',),
    mc_mater       = ('ELAS','MAZARS',),
    modelisation   = ('1D','C_PLAN',),
    deformation    = ('PETIT','PETIT_REAC','GROT_GDEP',),
    algo_inte      = ('ANALYTIQUE',),
    type_matr_tang = None,
    proprietes     = None,
    syme_matr_tang = ('No',),
)
