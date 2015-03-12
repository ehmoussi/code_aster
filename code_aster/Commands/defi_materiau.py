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

# person_in_charge: nicolas.sellenet@edf.fr

from code_aster import Materials
from code_aster.Cata import Commands
from code_aster.Utilities.CppToFortranGlossary import FortranGlossary


def DEFI_MATERIAU( **kwargs ):
    """Opérateur de définition d'un matériau"""
    Commands.DEFI_MATERIAU.checkSyntax( kwargs )

    import inspect
    dictMaterB = {}
    for key, value in Materials.MaterialBehaviour.__dict__.iteritems():
        if inspect.isclass( value ):
            if issubclass( value, Materials.MaterialBehaviour.GeneralMaterialBehaviour ):
                a = value()
                name = a.getAsterName()
                dictMaterB[ name ] = value

    mater = Materials.Material()

    for fkwName, fkw in kwargs.iteritems():
        if type( fkw ) == list:
            raise NameError( "Just on factor keywaord " + kwName + " allowed" )
        matBTmp = dictMaterB[ fkwName ]()
        for skwName, skw in fkw.iteritems():
            if type( skw ) == float:
                newName = skwName[0] + skwName[1:].lower()
                cRet = matBTmp.setDoubleValue( newName, skw )
                if not cRet:
                    raise NameError( "Problem with " + skwName + " keyword" )
            else:
                raise NameError( "Not yet implemented" )
        mater.addMaterialBehaviour( matBTmp )

    mater.build()

    return mater
