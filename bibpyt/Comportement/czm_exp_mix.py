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
    nom            = 'CZM_EXP_MIX',
    lc_type        = ('MECANIQUE',),
    doc            =   """Relation de comportement cohésive (Cohesive Zone Model EXPonentielle en formulation MIXte) (Cf. [R7.02.11]) modélisant l'ouverture et la  propagation d'une fissure. Cette loi est utilisable avec l'élément fini d'interface basé sur une formulation mixte
   lagrangien augmenté (Cf. [R3.06.13]) et permet d'introduire une force de cohésion entre les lèvres de la fissure en mode d'ouverture plus proche des matériaux quasi-fragile. Cette loi est utilisée lorsqu'on impose des conditions de symétrie sur l'élément d'interface.
   Par ailleurs l'utilisation de ce modèle requiert souvent la présence du pilotage par PRED_ELAS (cf. [U4.51.03])."""            ,
    num_lc         = 56,
    nb_vari        = 9,
    nom_vari       = ('SEUILDEP','INDIDISS','INDIENDO','PCENERDI','DISSIP',
        'ENEL_RES','SAUT_N','SAUT_T1','SAUT_T2',),
    mc_mater       = ('RUPT_FRAG','RUPT_FRAG_FO',),
    modelisation   = ('3D','PLAN','AXIS','INTERFAC',),
    deformation    = ('PETIT',),
    algo_inte      = ('ANALYTIQUE',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('Yes',),
    exte_vari      = None,
)
