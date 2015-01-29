# emulate LIRE_MAILLAGE / FORMAT='MED'

import os.path as osp

# from code_aster.RunManager.libFile import (
#     PyFileType as Type,
#     PyFileAccess as Access
# )
# from CommandSyntax import CommandSyntax, _F
from code_aster.Supervis.libCommandSyntax cimport CommandSyntax


cdef public emulate_LIRE_MAILLAGE_MED( ):
    """Read a MED file
    @param fileName path to the file to read
    @return true if it succeeds"""
    # cdef File medFile
    # if not osp.isfile( fileName ):
    #     raise IOError( 'No such file: {}'.format( fileName ) )
    #     return False
    # medFile = File( fileName, Type.Binary, Access.Old )
    #
    # syntax = CommandSyntax( "LIRE_MAILLAGE" )
    # syntax.setResult( initAster.getResultObjectName(), self.getType() )
    #
    # syntax.define( _F ( FORMAT="MED",
    #                     UNITE=medFile.getLogicalUnit(),
    #                     VERI_MAIL=_F( VERIF="OUI",
    #                                   APLAT=1.e-3 ),
    #                   )
    #              )
    #
    # cdef INTEGER numOp = 1
    # libaster.execop_( &numOp )
    # syntax.free()
    #
    # # Attention, la connection des objets a leur image JEVEUX n'est pas necessaire
    # self._dimensionInformations.updateValuePointer()
    # self._coordinates.updateValuePointer()
    # self._groupsOfNodes.buildFromJeveux()
    # self._connectivity.buildFromJeveux()
    # self._elementsType.updateValuePointer()
    # self._groupsOfElements.buildFromJeveux()
    # self._isEmpty = False

    return True
