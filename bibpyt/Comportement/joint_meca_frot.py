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
    nom            = 'JOINT_MECA_FROT',
    lc_type        = ('MECANIQUE',),
    doc            =   """Loi elastoplastique de Mohr-Coulomb avec adhesion pour modélisation de joints dans les barrages.
            Elle permet aussi de modéliser, avec les éléments  de joint hydro-mécaniques, un couplage entre
            la mécanique et l'écoulement de fluide dans la fissure """            ,
    num_lc         = 48,
    nb_vari        = 18,
    nom_vari       = ('LAMBDA','INDIPLAS','DEPPLAS1','DEPPLAS2','INDIOUV',
        'SIGT','SAUT_N','SAUT_T1','SAUT_T2','EPAISSJO',
        'SIGN_GLO','GRADP_X','GRADP_Y','GRADP_Z','FH_X',
        'FH_Y','FH_Z','PRESF',),
    mc_mater       = ('JOINT_MECA_FROT',),
    modelisation   = ('3D','PLAN','AXIS','ELEMJOINT','EJ_HYME',
        ),
    deformation    = ('PETIT',),
    algo_inte      = ('ANALYTIQUE',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('Yes',),
    exte_vari      = None,
)
