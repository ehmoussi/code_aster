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
from .affe_char_acou import AFFE_CHAR_ACOU
from .affe_char_cine import AFFE_CHAR_CINE
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
from .calc_fonc_interp import CALC_FONC_INTERP
from .calc_matr_elem import CALC_MATR_ELEM
from .calc_vect_elem import CALC_VECT_ELEM
from .crea_champ import CREA_CHAMP
# from .crea_maillage import CREA_MAILLAGE
from .crea_resu import CREA_RESU
from .crea_table import CREA_TABLE
from .debut import DEBUT, POURSUITE
from .defi_compor import DEFI_COMPOR
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
# from .defi_modele_gene import DEFI_MODELE_GENE
from .defi_nappe import DEFI_NAPPE
# from .defi_squelette import DEFI_SQUELETTE
from .defi_spec_turb import DEFI_SPEC_TURB
from .dyna_vibra import DYNA_VIBRA
from .fin import FIN
from .formule import FORMULE
from .lire_maillage import LIRE_MAILLAGE
# from .macr_elem_dyna import MACR_ELEM_DYNA
# from .macr_elem_stat import MACR_ELEM_STAT
from .maj_cata import MAJ_CATA
from .meca_statique import MECA_STATIQUE
# from .mode_iter_cycl import MODE_ITER_CYCL
from .mode_statique import MODE_STATIQUE
from .modi_maillage import MODI_MAILLAGE
from .nume_ddl import NUME_DDL
# from .nume_ddl_gene import NUME_DDL_GENE
from .proj_champ import PROJ_CHAMP
from .resoudre import RESOUDRE
from .stat_non_line import STAT_NON_LINE
from .recu_fonction import RECU_FONCTION

from .ExecuteCommand import CO


# other commands are automatically added just using their catalog
from .operator import define_operators
define_operators(globals())
del define_operators
