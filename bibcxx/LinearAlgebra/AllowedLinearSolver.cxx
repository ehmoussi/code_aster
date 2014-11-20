/**
 * @file AllowedLinearSolver.cxx
 * @brief Initialise les noms et possibles pour les solveurs et les renumeroteurs
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2014  EDF R&D                www.code-aster.org
 *
 *   This file is part of Code_Aster.
 *
 *   Code_Aster is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 2 of the License, or
 *   (at your option) any later version.
 *
 *   Code_Aster is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "LinearAlgebra/AllowedLinearSolver.h"

const char* LinearSolverNames[nbSolvers] = { "MULT_FRONT", "LDLT", "MUMPS", "PETSC", "GCPC" };
const char* RenumberingNames[nbRenumberings] = { "MD", "MDA", "METIS", "RCMK", "AMD",
                                                 "AMF", "PORD", "QAMD", "SCOTCH", "AUTO", "SANS" };


const Renumbering MultFrontRenumbering[nbRenumberingMultFront] = { MD, MDA, Metis };

const Renumbering LdltRenumbering[nbRenumberingLdlt] = { RCMK, Sans };

const Renumbering MumpsRenumbering[nbRenumberingMumps] = { AMD, AMF, PORD, Metis, QAMD, Scotch, Auto };

const Renumbering PetscRenumbering[nbRenumberingPetsc] = { RCMK, Sans };

const Renumbering GcpcRenumbering[nbRenumberingGcpc] = { RCMK, Sans };
