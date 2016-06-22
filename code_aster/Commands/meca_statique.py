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

from code_aster import Solvers, Loads, LinearAlgebra
from code_aster.Cata import Commands
from code_aster.Cata.SyntaxChecker import checkCommandSyntax
from code_aster.Utilities.CppToFortranGlossary import FortranGlossary


def _addLoad( mechaSolv, fkw ):
    load = fkw[ "CHARGE" ]
    if fkw.get( "FONC_MULT" ) != None:
        raise NameError( "Not yet implemented" )

    if isinstance( load, Loads.KinematicsLoad ):
        mechaSolv.addKinematicsLoad( load )
    elif isinstance( load, Loads.MechanicalLoad ):
        mechaSolv.addMechanicalLoad( load )
    else:
        assert False


def MECA_STATIQUE( **kwargs ):
    """Opérateur de résolution de mécanique statique linéaire"""
    checkCommandSyntax( Commands.MECA_STATIQUE, kwargs )

    retour = Commands.MECA_STATIQUE.getDefaultKeywords( kwargs )

    mechaSolv = Solvers.StaticMechanicalSolver()

    model = kwargs[ "MODELE" ]
    matOnMesh = kwargs[ "CHAM_MATER" ]
    mechaSolv.setSupportModel( model )
    mechaSolv.setMaterialOnMesh(matOnMesh  )

    if kwargs.get( "CARA_ELEM" ) != None:
        raise NameError( "Not yet implemented" )
    if kwargs.get( "INST" ) != None or kwargs.get( "LIST_INST" ) != None or \
        kwargs.get( "INST_FIN" ) != None:
        raise NameError( "Not yet implemented" )

    fkw = kwargs[ "EXCIT" ]
    if type( fkw ) == dict:
        _addLoad( mechaSolv, fkw )
    elif type( fkw ) == tuple:
        for curDict in fkw:
            _addLoad( mechaSolv, curDict )
    else:
        assert False

    methode = None
    renum = None

    fkwSolv = kwargs.get( "SOLVEUR" )
    if fkwSolv != None:
        for key, value in fkwSolv.iteritems():
            if key not in ( "METHODE", "RENUM" ):
                raise NameError( "Not yet implemented" )
        methode = fkwSolv[ "METHODE" ]
        renum = fkwSolv.get( "RENUM" )
        if renum == None: renum = retour[ "SOLVEUR" ][ "RENUM" ]
    else:
        methode = retour[ "SOLVEUR" ][ "METHODE" ]
        renum = retour[ "SOLVEUR" ][ "RENUM" ]

    glossary = FortranGlossary()
    solverInt = glossary.getSolver( methode )
    renumInt = glossary.getRenumbering( renum )
    print solverInt, renumInt
    currentSolver = LinearAlgebra.LinearSolver( solverInt, renumInt )

    mechaSolv.setLinearSolver( currentSolver )

    return mechaSolv.execute()
