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

from code_aster import Mesh, Model, KinematicsLoad
from code_aster.Cata import Commands
from code_aster.Utilities.CppToFortranGlossary import FortranGlossary


def _addLoad( load, fkwImpo, nameOfImpo ):
    glossary = FortranGlossary()

    kwTout = None
    kwGroupMa = None
    kwGroupNo = None
    for key, value in fkwImpo.iteritems():
        if key in ( "TOUT", "NOEUD", "MAILLE" ):
            raise NameError( key + " not permitted" )
        elif key == "GROUP_MA":
            kwGroupMa = fkwImpo.get( "GROUP_MA" )
        elif key == "GROUP_NO":
            kwGroupNo = fkwImpo.get( "GROUP_NO" )

    for key, value in fkwImpo.iteritems():
        if key not in ( "GROUP_MA", "GROUP_NO" ):
            composante = glossary.getComponent( key )
            if kwTout != None:
                raise NameError( "Load on all mesh is not available" )
            elif kwGroupMa != None:
                if nameOfImpo == "MECA_IMPO":
                    load.addImposedMechanicalDOFOnElements( composante, value, kwGroupMa )
                elif nameOfImpo == "THER_IMPO":
                    load.addImposedThermalDOFOnElements( composante, value, kwGroupMa )
                elif nameOfImpo == "ACOU_IMPO":
                    load.addImposedAcousticDOFOnElements( composante, value, kwGroupMa )
            elif kwGroupNo != None:
                if nameOfImpo == "MECA_IMPO":
                    load.addImposedMechanicalDOFOnNodes( composante, value, kwGroupNo )
                elif nameOfImpo == "THER_IMPO":
                    load.addImposedThermalDOFOnNodes( composante, value, kwGroupMa )
                elif nameOfImpo == "ACOU_IMPO":
                    load.addImposedAcousticDOFOnNodes( composante, value, kwGroupMa )

def AFFE_CHAR_CINE( **kwargs ):
    """Opérateur d'affection d'un chargement cinématique"""
    Commands.AFFE_CHAR_CINE.checkSyntax( kwargs )

    load = KinematicsLoad()
    load.setSupportModel( kwargs[ "MODELE" ] )

    fkwMecaImpo = kwargs.get( "MECA_IMPO" )
    if fkwMecaImpo != None:
        if type( fkwMecaImpo ) == tuple:
            for curDict in fkwMecaImpo:
                _addLoad( load, curDict, "MECA_IMPO" )
        elif type( fkwMecaImpo ) == dict:
            _addLoad( load, fkwMecaImpo, "MECA_IMPO" )

    fkwTherImpo = kwargs.get( "THER_IMPO" )
    if fkwTherImpo != None:
        if type( fkwTherImpo ) == tuple:
            for curDict in fkwTherImpo:
                _addLoad( load, curDict, "THER_IMPO" )
        elif type( fkwTherImpo ) == dict:
            _addLoad( load, fkwTherImpo, "THER_IMPO" )

    fkwAcouImpo = kwargs.get( "ACOU_IMPO" )
    if fkwAcouImpo != None:
        if type( fkwAcouImpo ) == tuple:
            for curDict in fkwAcouImpo:
                _addLoad( load, curDict, "ACOU_IMPO" )
        elif type( fkwAcouImpo ) == dict:
            _addLoad( load, fkwAcouImpo, "ACOU_IMPO" )

    fkwEvolImpo = kwargs.get( "EVOL_IMPO" )
    if fkwEvolImpo != None:
        raise NameError( "Not yet implemented" )

    load.build()

    return load
