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

# person_in_charge: samuel.geniaut at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'GRAN_IRRA_LOG',
    doc            =   """Relation de comportement de fluage et de grandissement sous irradiation pour les assemblages combustibles,
   similaire à la loi VISC_IRRA_LOG pour la déformation viscoplastique, et intégrant en plus une déformation de grandissement
   sous irradiation (cf. [R5.03.09]). Le champ de fluence est défini par le mot-clé AFFE_VARC de la commande AFFE_MATERIAU.
   Le grandissement ne se faisant que selon une direction, il est nécessaire dans les cas 3D et 2D de donner la direction du grandissement
   par l'opérande ANGL_REP du mot clé MASSIF de l'opérateur AFFE_CARA_ELEM"""          ,
    num_lc         = 28,
    nb_vari        = 3,
    nom_vari       = ('EPSPEQ','IRVECU','EPSGRD',),
    mc_mater       = ('GRAN_IRRA_LOG',),
    modelisation   = ('3D','AXIS','D_PLAN','1D',),
    deformation    = ('PETIT','PETIT_REAC','GROT_GDEP',),
    algo_inte      = ('ANALYTIQUE',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('Yes',),
    exte_vari      = None,
)
