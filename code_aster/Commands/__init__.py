# code_aster.Commands compatibility package

from ..Cata.Syntax import _F

# please keep alphabetical order
from .affe_cara_elem import AFFE_CARA_ELEM
from .affe_char_cine import AFFE_CHAR_CINE
from .affe_char_meca import AFFE_CHAR_MECA
from .affe_materiau import AFFE_MATERIAU
from .affe_modele import AFFE_MODELE
from .asse_matrice import ASSE_MATRICE
from .asse_matr_gene import ASSE_MATR_GENE
from .asse_vect_gene import ASSE_VECT_GENE
from .calc_fonc_interp import CALC_FONC_INTERP
from .calc_matr_elem import CALC_MATR_ELEM
from .comb_fourier import COMB_FOURIER
from .crea_champ import CREA_CHAMP
from .crea_maillage import CREA_MAILLAGE
from .crea_resu import CREA_RESU
from .crea_table import CREA_TABLE
from .defi_compor import DEFI_COMPOR
from .defi_fiss_xfem import DEFI_FISS_XFEM
from .defi_flui_stru import DEFI_FLUI_STRU
from .defi_fonc_flui import DEFI_FONC_FLUI
from .defi_fonction import DEFI_FONCTION
from .defi_fond_fiss import DEFI_FOND_FISS
from .defi_geom_fibre import DEFI_GEOM_FIBRE
from .defi_grille import DEFI_GRILLE
from .defi_group import DEFI_GROUP
from .defi_inte_spec import DEFI_INTE_SPEC
from .defi_interf_dyna import DEFI_INTERF_DYNA
from .defi_list_reel import DEFI_LIST_REEL
from .defi_materiau import DEFI_MATERIAU
from .defi_modele_gene import DEFI_MODELE_GENE
from .defi_nappe import DEFI_NAPPE
from .defi_squelette import DEFI_SQUELETTE
from .defi_spec_turb import DEFI_SPEC_TURB
from .fin import FIN
from .lire_maillage import LIRE_MAILLAGE
from .macr_elem_dyna import MACR_ELEM_DYNA
from .macr_elem_stat import MACR_ELEM_STAT
from .meca_statique import MECA_STATIQUE
from .mode_iter_cycl import MODE_ITER_CYCL
from .mode_statique import MODE_STATIQUE
from .modi_maillage import MODI_MAILLAGE
from .nume_ddl import NUME_DDL
from .nume_ddl_gene import NUME_DDL_GENE
from .proj_champ import PROJ_CHAMP
from .stat_non_line import STAT_NON_LINE

from .macro_commands import (
    ASSEMBLAGE, DEBUT, IMPR_FONCTION,
)