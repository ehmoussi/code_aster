# coding: utf-8

# Copyright (C) 1991 - 2015  EDF R&D                www.code-aster.org
#
# This file is part of Code_Aster.
#
# Code_Aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# Code_Aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.

# Emulate commands for Mesh object

import os.path as osp


cdef public bint emulateLIRE_MAILLAGE_MED( MeshInstance* inst ):
    """Read a MED file
    @param fileName path to the file to read
    @return true if it succeeds"""
    # cdef File medFile
    # if not osp.isfile( fileName ):
    #     raise IOError( 'No such file: {}'.format( fileName ) )
    #     return False
    # medFile = File( fileName, Type.Binary, Access.Old )
    #
    syntax = CommandSyntax( "LIRE_MAILLAGE" )
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
    syntax.free()
    #
    # # Attention, la connection des objets a leur image JEVEUX n'est pas necessaire
    # self._dimensionInformations.updateValuePointer()
    # self._coordinates.updateValuePointer()
    # self._groupsOfNodes.buildFromJeveux()
    # self._connectivity.buildFromJeveux()
    # self._elementsType.updateValuePointer()
    # self._groupsOfElements.buildFromJeveux()
    # self._isEmpty = False

    print "Hello from emulateLIRE_MAILLAGE_MED"

    return True
