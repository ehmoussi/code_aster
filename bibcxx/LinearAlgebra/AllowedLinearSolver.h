#ifndef ALLOWEDLINEARSOLVER_H_
#define ALLOWEDLINEARSOLVER_H_

/**
 * @file AllowedLinearSolver.h
 * @brief Fichier permettant de definir les solveurs et les renumeroteurs
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

/* person_in_charge: nicolas.sellenet at edf.fr */

/**
 * @enum LinearSolverEnum
 * @brief Tous les solveurs lineaires de Code_Aster
 * @author Nicolas Sellenet
 */
enum LinearSolverEnum { MultFront, Ldlt, Mumps, Petsc, Gcpc };
const int nbSolvers = 5;
extern const char* LinearSolverNames[nbSolvers];

/**
 * @enum Renumbering
 * @brief Declaration des renumeroteurs
 * @author Nicolas Sellenet
 */
enum Renumbering { MD, MDA, Metis, RCMK, AMD, AMF, PORD, QAMD, Scotch, Auto, Sans };
const int nbRenumberings = 11;
extern const char* RenumberingNames[nbRenumberings];

const int nbRenumberingMultFront = 3;
extern const Renumbering MultFrontRenumbering[nbRenumberingMultFront];

const int nbRenumberingLdlt = 2;
extern const Renumbering LdltRenumbering[nbRenumberingLdlt];

const int nbRenumberingMumps = 7;
extern const Renumbering MumpsRenumbering[nbRenumberingMumps];

const int nbRenumberingPetsc = 2;
extern const Renumbering PetscRenumbering[nbRenumberingPetsc];

const int nbRenumberingGcpc = 2;
extern const Renumbering GcpcRenumbering[nbRenumberingGcpc];

/**
 * @enum Preconditioning
 * @author Nicolas Sellenet
 */
enum Preconditioning { IncompleteLdlt, SimplePrecisionLdlt, Jacobi, Sor, Ml,
                       Boomer, Gamg, LagrBloc, Without };
const int nbPreconditionings = 9;
extern const char* PreconditioningNames[nbPreconditionings];

const int nbPreconditioningGcpc = 3;
extern const Preconditioning GcpcPreconditioning[nbPreconditioningGcpc];

/**
 * @enum IterativeSolverAlgorithm
 * @author Nicolas Sellenet
 */
enum IterativeSolverAlgorithm { ConjugateGradiant, ConjugateResidual, GMRes, GCR, FGMRes };
const int nbIterativeSolverAlgorithms = 5;
extern const char* IterativeSolverAlgorithmNames[nbIterativeSolverAlgorithms];

/**
 * @enum LagrangeTreatment
 * @author Nicolas Sellenet
 */
enum LagrangeTreatment { Eliminate, NotEliminate, DoubleLagrangeEliminate };
const int nbLagrangeTreatments = 3;
extern const char* LagrangeTreatmentNames[nbLagrangeTreatments];

/**
 * @enum MemoryManagement
 * @author Nicolas Sellenet
 */
enum MemoryManagement { InCore, OutOfCore, Automatic, Evaluation };
const int nbMemoryManagements = 4;
extern const char* MemoryManagementNames[nbMemoryManagements];

/**
 * @enum MatrixType
 * @author Nicolas Sellenet
 */
enum MatrixType { NonSymetric, Symetric, SymetricPositiveDefinite, Undefined };
const int nbMatrixTypes = 4;
extern const char* MatrixTypeNames[nbMatrixTypes];

#endif /* ALLOWEDLINEARSOLVER_H_ */
