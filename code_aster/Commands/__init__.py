# code_aster.Commands compatibility package

__all__ = ['_F', 'DEFI_FONCTION', 'DEFI_LIST_REEL']

def _F( **kwargs ):
    return kwargs

from code_aster.Commands.defi_list_reel import DEFI_LIST_REEL
from code_aster.Commands.defi_fonction import DEFI_FONCTION
