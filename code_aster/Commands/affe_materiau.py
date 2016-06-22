# coding: utf-8

# Copyright (C) 1991 - 2016  EDF R&D                www.code-aster.org
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

# person_in_charge: nicolas.sellenet@edf.fr

from code_aster import Materials
from code_aster.Cata import Commands
from code_aster.Cata.SyntaxChecker import checkCommandSyntax


def _addMaterial( materOnMesh, fkw ):
    kwTout = fkw.get( "TOUT" )
    kwGrMa = fkw.get( "GROUP_MA" )
    mater = fkw[ "MATER" ]

    if kwTout != None:
        materOnMesh.addMaterialOnAllMesh( mater )
    elif kwGrMa != None:
        materOnMesh.addMaterialOnGroupOfElements( mater, kwGrMa )
    else: assert False

def AFFE_MATERIAU( **kwargs ):
    """Opérateur d'affection d'un matériau"""
    checkCommandSyntax( Commands.AFFE_MATERIAU, kwargs )

    materOnMesh = Materials.MaterialOnMesh()

    if kwargs.get( "MODELE" ) != None:
        raise NameError( "A Mesh is required, not a Model (not yet implemented)" )

    materOnMesh.setSupportMesh( kwargs[ "MAILLAGE" ] )

    if kwargs.get( "AFFE_COMPOR" ) != None or kwargs.get( "AFFE_VARC" ) != None:
        raise NameError( "AFFE_COMPOR or AFFE_VARC not yet implemented" )

    fkw = kwargs[ "AFFE" ]
    if type( fkw ) == dict:
        _addMaterial( materOnMesh, fkw )
    elif type( fkw ) == tuple:
        for curDict in fkw:
            _addMaterial( materOnMesh,curDict  )
    else:
        assert False

    materOnMesh.build()

    return materOnMesh
