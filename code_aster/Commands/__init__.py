# code_aster.Commands compatibility package

__all__ = ['_F',             'AFFE_CHAR_CINE', 'AFFE_MATERIAU',  'AFFE_MODELE',    'DEFI_FONCTION',
           'DEFI_LIST_REEL', 'DEFI_MATERIAU',  'LIRE_MAILLAGE',  'MECA_STATIQUE',  'DEFI_FISS_XFEM',
          ]

from code_aster.Cata.Syntax import _F

from code_aster.Commands.affe_char_cine import AFFE_CHAR_CINE
from code_aster.Commands.affe_materiau import AFFE_MATERIAU
from code_aster.Commands.affe_modele import AFFE_MODELE
from code_aster.Commands.defi_fonction import DEFI_FONCTION
from code_aster.Commands.defi_list_reel import DEFI_LIST_REEL
from code_aster.Commands.defi_materiau import DEFI_MATERIAU
from code_aster.Commands.lire_maillage import LIRE_MAILLAGE
from code_aster.Commands.meca_statique import MECA_STATIQUE
from code_aster.Commands.defi_fiss_xfem import DEFI_FISS_XFEM
