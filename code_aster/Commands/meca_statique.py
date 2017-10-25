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

from code_aster import MultFrontSolver, LdltSolver, MumpsSolver, PetscSolver, GcpcSolver
from code_aster import StaticMechanicalSolver, KinematicsLoad, GenericMechanicalLoad
from code_aster import ParallelMechanicalLoad
from code_aster.Cata import Commands, checkSyntax
from code_aster import getGlossary


def _addLoad( mechaSolv, fkw ):
    load = fkw[ "CHARGE" ]
    if fkw.get( "FONC_MULT" ):
        raise NotImplementedError( "Unsupported keyword: {0}".format("FONC_MULT") )

    if isinstance( load, KinematicsLoad ):
        mechaSolv.addKinematicsLoad( load )
    elif isinstance( load, GenericMechanicalLoad ):
        mechaSolv.addMechanicalLoad( load )
    elif isinstance( load, ParallelMechanicalLoad ):
        mechaSolv.addParallelMechanicalLoad( load )
    else:
        assert False


def MECA_STATIQUE( **kwargs ):
    """Opérateur de résolution de mécanique statique linéaire"""
    checkSyntax( Commands.MECA_STATIQUE, kwargs )

    mechaSolv = StaticMechanicalSolver.create()

    model = kwargs[ "MODELE" ]
    matOnMesh = kwargs[ "CHAM_MATER" ]
    mechaSolv.setSupportModel( model )
    mechaSolv.setMaterialOnMesh( matOnMesh )

    if kwargs.get( "CARA_ELEM" ):
        raise NotImplementedError("Unsupported keyword: '{0}'".format("CARA_ELEM"))
    if kwargs.get( "LIST_INST" ) != None or kwargs.get( "INST_FIN" ) != None:
        raise NotImplementedError("Unsupported keywords: '{0}'".format(("LIST_INST", "INST_FIN")))

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

    fkwSolv = kwargs["SOLVEUR"]
    for key, value in fkwSolv.iteritems():
        if key not in ( "METHODE", "RENUM", "PRE_COND", "RESI_RELA" ):
            print(NotImplementedError("Not yet implemented: '{0}' is ignored".format(key)))
    methode = fkwSolv[ "METHODE" ]
    renum = fkwSolv[ "RENUM" ]
    # TODO: a modifier si undef
    precond = fkwSolv[ "PRE_COND" ]
    resiRela = fkwSolv[ "RESI_RELA" ]

    glossary = getGlossary()
    solverInt = glossary.getSolver( methode )
    renumInt = glossary.getRenumbering( renum )
    precondInt = glossary.getPreconditioning( precond )
    currentSolver = None
    if methode == "MULT_FRONT": currentSolver = MultFrontSolver.create( renumInt )
    elif methode == "LDLT": currentSolver = LdltSolver.create( renumInt )
    elif methode == "MUMPS": currentSolver = MumpsSolver.create( renumInt )
    elif methode == "PETSC": currentSolver = PetscSolver.create( renumInt )
    elif methode == "GCPC": currentSolver = GcpcSolver.create( renumInt )
    currentSolver.setPreconditioning( precondInt )
    currentSolver.setSolverResidual(resiRela)

    mechaSolv.setLinearSolver( currentSolver )

    return mechaSolv.execute()
