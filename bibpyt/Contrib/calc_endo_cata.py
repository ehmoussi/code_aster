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

from calc_endo_ops import calc_endo_ops

from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


CALC_ENDO=MACRO(
    nom       = "CALC_ENDO",
    op        = calc_endo_ops,
    sd_prod   = evol_noli,
    reentrant = 'n',
    fr        = "Calcul d'endommagement automatisé à partir d'un état initial",

    MODELE          = SIMP(statut='o',typ=modele_sdaster),
    CHAM_MATER      = SIMP(statut='o',typ=cham_mater),
    CARA_ELEM       = SIMP(statut='f',typ=cara_elem),
    EXCIT           = FACT(statut='o',max='**',
        CHARGE          = SIMP(statut='o',typ=(char_meca,char_cine_meca)),
        FONC_MULT       = SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule)),
        TYPE_CHARGE     = SIMP(statut='f',typ='TXM',defaut="FIXE_CSTE",
                              into=("FIXE_CSTE","FIXE_PILO","SUIV","DIDI")),
        ),
#-------------------------------------------------------------------
    COMPORTEMENT    = C_COMPORTEMENT('STAT_NON_LINE'),
#-------------------------------------------------------------------
    ETAT_INIT       = FACT(statut='f',max=1,
        UNITE           = SIMP(statut='F', typ='I', defaut=20),
        NOM_CHAM_MED    = SIMP(statut='F', typ='TXM', defaut='VARI'),
        ),
#-------------------------------------------------------------------
    INCREMENT       = FACT(statut='d', max=1,
        NOMBRE          = SIMP(statut='F', typ='I', defaut=5),
        ),
#-------------------------------------------------------------------
    PILOTAGE        = FACT(statut='o', max=1,
        regles          = (PRESENT_ABSENT('TOUT','GROUP_MA'),),
        TYPE            = SIMP(statut='c',typ='TXM',defaut='PRED_ELAS'),
        COEF_MULT       = SIMP(statut='c',typ='R',defaut=10.0),
        ETA_PILO_MAX    = SIMP(statut='f',typ='R'),
        ETA_PILO_MIN    = SIMP(statut='f',typ='R'),
        ETA_PILO_R_MAX  = SIMP(statut='f',typ='R'),
        ETA_PILO_R_MIN  = SIMP(statut='f',typ='R'),
        PROJ_BORNES     = SIMP(statut='f',typ='TXM',defaut="OUI",into=("OUI","NON")),
        SELECTION       = SIMP(statut='f',typ='TXM',defaut="MIXTE",
                            into=("RESIDU","MIXTE","ANGL_INCR_DEPL","NORM_INCR_DEPL")),
        TOUT            = SIMP(statut='f',typ='TXM',into=("OUI",) ),
        GROUP_MA        = SIMP(statut='f',typ=grma ,validators=NoRepeat(),max='**'),
        ),
#--------------------------------------------------------------
    CONVERGENCE     = FACT(statut='o', max=1,
        SIGM_REFE       =SIMP(statut='o',typ='R'),
        LAGR_REFE       =SIMP(statut='f',typ='R'),
        VARI_REFE       =SIMP(statut='f',typ='R',defaut=1.0),
        RESI_REFE_RELA  =SIMP(statut='f',typ='R',defaut=1.e-3),
        ITER_GLOB_MAXI  =SIMP(statut='f',typ='I',defaut=20),
        ITER_GLOB_ELAS  =SIMP(statut='f',typ='I',defaut=100),
        ARRET           =SIMP(statut='f',typ='TXM',defaut="OUI",into=("OUI","NON")),
        ),
#--------------------------------------------------------------
    SOLVEUR         = C_SOLVEUR('STAT_NON_LINE'),
#--------------------------------------------------------------
    ARCHIVAGE       = C_ARCHIVAGE(),
#--------------------------------------------------------------
    IMPR            = FACT(statut='f', max=1,
        UNITE           = SIMP(statut='f',typ='I',defaut=80),
        FILTRE          = SIMP(statut='f',typ='TXM',defaut='OUI',into=('OUI','NON')),
        ),
#--------------------------------------------------------------
    INFO            = SIMP(statut='f',typ='I',into=(1,2) ),
    TITRE           = SIMP(statut='f',typ='TXM',max='**' ),
    )
