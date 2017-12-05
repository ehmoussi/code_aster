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

"""
:py:mod:`__init__` --- Definition of user's Commands
****************************************************

All user's Commands are imported from this module.

*Work in progress*: Commented Commands have not yet been migrated using
:py:class:`~code_aster.Commands.ExecuteCommand.ExecuteCommand`.

By default, an automatic implementation of all Commands are published here
using their catalog definition.

"""

# please keep alphabetical order
from .affe_cara_elem import AFFE_CARA_ELEM
from .affe_char_acou import AFFE_CHAR_ACOU
from .affe_char_cine import AFFE_CHAR_CINE
from .affe_char_cine_f import AFFE_CHAR_CINE_F
from .affe_char_meca import AFFE_CHAR_MECA
from .affe_char_meca_f import AFFE_CHAR_MECA_F
from .affe_materiau import AFFE_MATERIAU
from .affe_modele import AFFE_MODELE
from .asse_matrice import ASSE_MATRICE
from .asse_vecteur import ASSE_VECTEUR
# from .asse_matr_gene import ASSE_MATR_GENE
# from .asse_vect_gene import ASSE_VECT_GENE
from .calc_champ import CALC_CHAMP
from .calc_char_cine import CALC_CHAR_CINE
from .calc_cham_elem import CALC_CHAM_ELEM
from .calc_char_cine import CALC_CHAR_CINE
from .calc_fatigue import CALC_FATIGUE
from .calc_ferraillage import CALC_FERRAILLAGE
from .calc_fonction import CALC_FONCTION
from .calc_fonc_interp import CALC_FONC_INTERP
from .calc_forc_nonl import CALC_FORC_NONL
from .calc_matr_elem import CALC_MATR_ELEM
from .calc_meta import CALC_META
from .calc_table import CALC_TABLE
from .calc_vect_elem import CALC_VECT_ELEM
from .copier import COPIER
from .crea_champ import CREA_CHAMP
# from .crea_maillage import CREA_MAILLAGE
from .crea_resu import CREA_RESU
from .crea_table import CREA_TABLE
from .debug import DEBUG
from .debut import DEBUT, POURSUITE
from .defi_obstacle import DEFI_OBSTACLE
from .defi_cable_bp import DEFI_CABLE_BP
from .defi_cable_op import DEFI_CABLE_OP
from .defi_compor import DEFI_COMPOR
from .defi_composite import DEFI_COMPOSITE
from .defi_constante import DEFI_CONSTANTE
from .defi_fichier import DEFI_FICHIER
from .defi_fiss_xfem import DEFI_FISS_XFEM
from .defi_flui_stru import DEFI_FLUI_STRU
from .defi_fonc_flui import DEFI_FONC_FLUI
from .defi_fonction import DEFI_FONCTION
from .defi_fond_fiss import DEFI_FOND_FISS
from .defi_geom_fibre import DEFI_GEOM_FIBRE
from .defi_grille import DEFI_GRILLE
from .defi_group import DEFI_GROUP
from .defi_inte_spec import DEFI_INTE_SPEC
# from .defi_interf_dyna import DEFI_INTERF_DYNA
from .defi_list_reel import DEFI_LIST_REEL
from .defi_materiau import DEFI_MATERIAU
from .defi_mater_gc import DEFI_MATER_GC
# from .defi_modele_gene import DEFI_MODELE_GENE
from .defi_nappe import DEFI_NAPPE
# from .defi_squelette import DEFI_SQUELETTE
from .defi_spec_turb import DEFI_SPEC_TURB
from .detruire import DETRUIRE
from .dyna_non_line import DYNA_NON_LINE
from .dyna_vibra import DYNA_VIBRA
from .engendre_test import ENGENDRE_TEST
from .exec_logiciel import EXEC_LOGICIEL
from .extr_resu import EXTR_RESU
from .extr_table import EXTR_TABLE
from .factoriser import FACTORISER
from .fin import FIN
from .formule import FORMULE
from .impr_fonction import IMPR_FONCTION
from .impr_table import IMPR_TABLE
from .impr_resu import IMPR_RESU
from .lire_maillage import LIRE_MAILLAGE
# from .macr_elem_dyna import MACR_ELEM_DYNA
# from .macr_elem_stat import MACR_ELEM_STAT
from .macr_lign_coupe import MACR_LIGN_COUPE
from .maj_cata import MAJ_CATA
from .macr_adap_mail import MACR_ADAP_MAIL
from .macr_cara_poutre import MACR_CARA_POUTRE
from .macr_info_mail import MACR_INFO_MAIL
from .macro_elas_mult import MACRO_ELAS_MULT
from .meca_statique import MECA_STATIQUE
# from .mode_iter_cycl import MODE_ITER_CYCL
from .mode_statique import MODE_STATIQUE
from .modi_maillage import MODI_MAILLAGE
from .modi_modele import MODI_MODELE
from .modi_repere import MODI_REPERE
from .nume_ddl import NUME_DDL
# from .nume_ddl_gene import NUME_DDL_GENE
from .post_bordet import POST_BORDET
from .post_champ import POST_CHAMP
from .post_coque import POST_COQUE
from .post_elem import POST_ELEM
from .post_fati_alea import POST_FATI_ALEA
from .post_fatigue import POST_FATIGUE
from .post_releve_t import POST_RELEVE_T
from .post_usure import POST_USURE
from .prod_matr_cham import PROD_MATR_CHAM
from .proj_champ import PROJ_CHAMP
from .resoudre import RESOUDRE
from .stat_non_line import STAT_NON_LINE
from .reca_weibull import RECA_WEIBULL
from .recu_fonction import RECU_FONCTION
from .recu_table import RECU_TABLE
from .resoudre import RESOUDRE
from .test_resu import TEST_RESU
from .test_table import TEST_TABLE

from .ExecuteCommand import CO


# other commands are automatically added just using their catalog
from .operator import define_operators
define_operators(globals())
del define_operators
