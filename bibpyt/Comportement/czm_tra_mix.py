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
    nom            = 'CZM_TRA_MIX',
    doc            =   """Relation de comportement cohésive (Cohesive Zone Model TRApèze MIXte) pour la rupture ductile (Cf. [R7.02.11]) modélisant l'ouverture et la
   propagation d'une fissure. Cette loi est utilisable avec l'élément fini d'interface basé sur une formulation mixte lagrangien augmenté (Cf. [R3.06.13]) """      ,
    num_lc         = 49,
    nb_vari        = 9,
    nom_vari       = ('SEUILDEP','INDIDISS','INDIENDO','PCENERDI','DISSIP',
        'ENEL_RES','SAUT_N','SAUT_T1','SAUT_T2',),
    mc_mater       = ('RUPT_FRAG',),
    modelisation   = ('3D','PLAN','AXIS','INTERFAC',),
    deformation    = ('PETIT',),
    algo_inte      = ('ANALYTIQUE',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('Yes',),
)
