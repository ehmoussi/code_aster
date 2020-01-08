# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

"""
:py:mod:`__init__` --- Definition of user's Commands
****************************************************

All user's Commands are imported from this module.

By default, an automatic implementation of all Commands are published here
using their catalog definition.

"""

from ..Supervis.ExecuteCommand import CO

# please keep alphabetical order
from .affe_cara_elem import AFFE_CARA_ELEM
from .affe_char_acou import AFFE_CHAR_ACOU
from .affe_char_cine import AFFE_CHAR_CINE
from .affe_char_cine_f import AFFE_CHAR_CINE_F
from .affe_char_meca import AFFE_CHAR_MECA
from .affe_char_meca_c import AFFE_CHAR_MECA_C
from .affe_char_meca_f import AFFE_CHAR_MECA_F
from .affe_char_ther import AFFE_CHAR_THER
from .affe_char_ther_f import AFFE_CHAR_THER_F
from .affe_materiau import AFFE_MATERIAU
from .affe_modele import AFFE_MODELE
from .asse_maillage import ASSE_MAILLAGE
from .asse_matrice import ASSE_MATRICE
from .asse_vecteur import ASSE_VECTEUR
from .asse_matr_gene import ASSE_MATR_GENE
from .asse_vect_gene import ASSE_VECT_GENE
from .calc_amor_modal import CALC_AMOR_MODAL
from .calc_champ import CALC_CHAMP
from .calc_char_cine import CALC_CHAR_CINE
from .calc_char_seisme import CALC_CHAR_SEISME
from .calc_cham_elem import CALC_CHAM_ELEM
from .calc_cham_flui import CALC_CHAM_FLUI
from .calc_char_cine import CALC_CHAR_CINE
from .calc_corr_ssd import CALC_CORR_SSD
from .calc_erc_dyn import CALC_ERC_DYN
from .calc_erreur import CALC_ERREUR
from .calc_fatigue import CALC_FATIGUE
from .calc_ferraillage import CALC_FERRAILLAGE
from .calc_flui_stru import CALC_FLUI_STRU
from .calc_fonc_interp import CALC_FONC_INTERP
from .calc_forc_ajou import CALC_FORC_AJOU
from .calc_forc_nonl import CALC_FORC_NONL
from .calc_g import CALC_G
from .calc_h import CALC_H
from .calc_inte_spec import CALC_INTE_SPEC
from .calc_matr_ajou import CALC_MATR_AJOU
from .calc_matr_elem import CALC_MATR_ELEM
from .calc_meta import CALC_META
from .calc_point_mat import CALC_POINT_MAT
from .calc_vect_elem import CALC_VECT_ELEM
from .calcul import CALCUL
from .comb_fourier import COMB_FOURIER
from .comb_matr_asse import COMB_MATR_ASSE
from .comb_sism_modal import COMB_SISM_MODAL
from .copier import COPIER
from .crea_champ import CREA_CHAMP
from .crea_maillage import CREA_MAILLAGE
from .crea_resu import CREA_RESU
from .crea_table import CREA_TABLE
from .debut import DEBUT, POURSUITE
from .defi_base_modale import DEFI_BASE_MODALE
from .defi_obstacle import DEFI_OBSTACLE
from .defi_cable_op import DEFI_CABLE_OP
from .defi_compor import DEFI_COMPOR
from .defi_composite import DEFI_COMPOSITE
from .defi_constante import DEFI_CONSTANTE
from .defi_base_reduite import DEFI_BASE_REDUITE
from .defi_contact import DEFI_CONTACT
from .defi_domaine_reduit import DEFI_DOMAINE_REDUIT
from .defi_fichier import DEFI_FICHIER
from .defi_fiss_xfem import DEFI_FISS_XFEM
from .defi_flui_stru import DEFI_FLUI_STRU
from .defi_fonc_flui import DEFI_FONC_FLUI
from .defi_fonction import DEFI_FONCTION
from .defi_fond_fiss import DEFI_FOND_FISS
from .defi_fissure import DEFI_FISSURE
from .defi_geom_fibre import DEFI_GEOM_FIBRE
from .defi_glrc import DEFI_GLRC
from .defi_grille import DEFI_GRILLE
from .defi_group import DEFI_GROUP
from .defi_inte_spec import DEFI_INTE_SPEC
from .defi_interf_dyna import DEFI_INTERF_DYNA
from .defi_list_enti import DEFI_LIST_ENTI
from .defi_list_inst import DEFI_LIST_INST
from .defi_list_reel import DEFI_LIST_REEL
from .defi_maillage import DEFI_MAILLAGE
from .defi_materiau import DEFI_MATERIAU
from .defi_modele_gene import DEFI_MODELE_GENE
from .defi_nappe import DEFI_NAPPE
from .defi_obstacle import DEFI_OBSTACLE
from .defi_squelette import DEFI_SQUELETTE
from .defi_spec_turb import DEFI_SPEC_TURB
from .defi_trc import DEFI_TRC
from .depl_interne import DEPL_INTERNE
from .detruire import DETRUIRE
from .dyna_alea_modal import DYNA_ALEA_MODAL
from .dyna_non_line import DYNA_NON_LINE
from .dyna_spec_modal import DYNA_SPEC_MODAL
from .dyna_vibra import DYNA_VIBRA
from .elim_lagr import ELIM_LAGR
from .engendre_test import ENGENDRE_TEST
from .extr_mode import EXTR_MODE
from .extr_resu import EXTR_RESU
from .extr_table import EXTR_TABLE
from .factoriser import FACTORISER
from .fin import FIN
from .fonc_flui_stru import FONC_FLUI_STRU
from .formule import FORMULE
from .gene_fonc_alea import GENE_FONC_ALEA
from .impr_co import IMPR_CO
from .info_exec_aster import INFO_EXEC_ASTER
from .impr_jeveux import IMPR_JEVEUX
from .impr_resu import IMPR_RESU
from .info_mode import INFO_MODE
from .info_resu import INFO_RESU
from .impr_macr_elem import IMPR_MACR_ELEM
from .lire_champ import LIRE_CHAMP
from .lire_forc_miss import LIRE_FORC_MISS
from .lire_impe_miss import LIRE_IMPE_MISS
from .lire_maillage import LIRE_MAILLAGE
from .lire_plexus import LIRE_PLEXUS
from .lire_resu import LIRE_RESU
from .mac_modes import MAC_MODES
from .macr_elem_dyna import MACR_ELEM_DYNA
from .macr_elem_stat import MACR_ELEM_STAT
from .maj_cata import MAJ_CATA
from .meca_statique import MECA_STATIQUE
from .mode_iter_cycl import MODE_ITER_CYCL
from .mode_non_line import MODE_NON_LINE
from .mode_statique import MODE_STATIQUE
from .modi_maillage import MODI_MAILLAGE
from .modi_base_modale import MODI_BASE_MODALE
from .modi_modele import MODI_MODELE
from .modi_modele_xfem import MODI_MODELE_XFEM
from .modi_repere import MODI_REPERE
from .nume_ddl import NUME_DDL
from .nume_ddl_gene import NUME_DDL_GENE
from .norm_mode import NORM_MODE
from .post_champ import POST_CHAMP
from .post_cham_xfem import POST_CHAM_XFEM
from .post_dyna_moda_t import POST_DYNA_MODA_T
from .post_elem import POST_ELEM
from .post_fati_alea import POST_FATI_ALEA
from .post_fatigue import POST_FATIGUE
from .post_gene_phys import POST_GENE_PHYS
from .post_k_beta import POST_K_BETA
from .post_mail_xfem import POST_MAIL_XFEM
from .post_rccm import POST_RCCM
from .post_releve_t import POST_RELEVE_T
from .post_usure import POST_USURE
from .pre_gibi import PRE_GIBI
from .pre_gmsh import PRE_GMSH
from .pre_ideas import PRE_IDEAS
from .prod_matr_cham import PROD_MATR_CHAM
from .proj_champ import PROJ_CHAMP
from .proj_matr_base import PROJ_MATR_BASE
from .proj_mesu_modal import PROJ_MESU_MODAL
from .proj_spec_base import PROJ_SPEC_BASE
from .proj_vect_base import PROJ_VECT_BASE
from .recu_gene import RECU_GENE
from .resoudre import RESOUDRE
from .rest_cond_tran import REST_COND_TRAN
from .rest_mode_nonl import REST_MODE_NONL
from .stat_non_line import STAT_NON_LINE
from .reca_weibull import RECA_WEIBULL
from .recu_fonction import RECU_FONCTION
from .recu_table import RECU_TABLE
from .rest_gene_phys import REST_GENE_PHYS
from .rest_sous_struc import REST_SOUS_STRUC
from .rest_spec_phys import REST_SPEC_PHYS
from .rest_spec_temp import REST_SPEC_TEMP
from .rest_reduit_complet import REST_REDUIT_COMPLET
from .resoudre import RESOUDRE
from .test_resu import TEST_RESU
from .test_table import TEST_TABLE
from .ther_non_line import THER_NON_LINE
from .ther_lineaire import THER_LINEAIRE
from .ther_non_line_mo import THER_NON_LINE_MO
from .variable import VARIABLE


# other commands are automatically added just using their catalog
from .operator import define_operators
define_operators(globals())
del define_operators
