/**
 * @file LinearSolverInterface.cxx
 * @brief Interface python de LinearSolver
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2020  EDF R&D                www.code-aster.org
 *
 *   This file is part of Code_Aster.
 *
 *   Code_Aster is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
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

#include <boost/python.hpp>

namespace py = boost::python;
#include <PythonBindings/factory.h>
#include "PythonBindings/LinearSolverInterface.h"

BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( solveRealLinearSystemWithKinematicsLoad_overloads,
                                        solveRealLinearSystemWithKinematicsLoad, 3, 4 )
BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( solveRealLinearSystem_overloads, solveRealLinearSystem,
                                        2, 3 )

void exportLinearSolverToPython() {

    py::enum_< LinearSolverEnum >( "BaseLinearSolverName" )
        .value( "MultFront", MultFront )
        .value( "Ldlt", Ldlt )
        .value( "Mumps", Mumps )
        .value( "Petsc", Petsc )
        .value( "Gcpc", Gcpc );

    py::enum_< Renumbering >( "Renumbering" )
        .value( "MD", MD )
        .value( "MDA", MDA )
        .value( "Metis", Metis )
        .value( "RCMK", RCMK )
        .value( "AMD", AMD )
        .value( "AMF", AMF )
        .value( "PORD", PORD )
        .value( "QAMD", QAMD )
        .value( "Scotch", Scotch )
        .value( "Auto", Auto )
        .value( "Parmetis", Parmetis )
        .value( "Ptscotch", Ptscotch )
        .value( "Sans", Sans );

    py::enum_< Preconditioning >( "Preconditioning" )
        .value( "IncompleteLdlt", IncompleteLdlt )
        .value( "SimplePrecisionLdlt", SimplePrecisionLdlt )
        .value( "Jacobi", Jacobi )
        .value( "Sor", Sor )
        .value( "Ml", Ml )
        .value( "Boomer", Boomer )
        .value( "Gamg", Gamg )
        .value( "LagrBloc", LagrBloc )
        .value( "Without", Without );

    py::enum_< IterativeSolverAlgorithm >( "IterativeSolverAlgorithm" )
        .value( "ConjugateGradiant", ConjugateGradiant )
        .value( "ConjugateResidual", ConjugateResidual )
        .value( "GMRes", GMRes )
        .value( "GCR", GCR )
        .value( "FGMRes", FGMRes );

    py::enum_< LagrangeTreatment >( "LagrangeTreatment" )
        .value( "Eliminate", Eliminate )
        .value( "NotEliminate", NotEliminate )
        .value( "RealLagrangeEliminate", RealLagrangeEliminate );

    py::enum_< MemoryManagement >( "MemoryManagement" )
        .value( "InCore", InCore )
        .value( "OutOfCore", OutOfCore )
        .value( "Automatic", Automatic )
        .value( "Evaluation", Evaluation );

    py::enum_< MatrixType >( "MatrixType" )
        .value( "NonSymetric", NonSymetric )
        .value( "Symetric", Symetric )
        .value( "SymetricPositiveDefinite", SymetricPositiveDefinite )
        .value( "Undefined", Undefined );

    py::enum_< MumpsPostTreatment >( "MumpsPostTreatment" )
        .value( "WithoutPostTreatment", WithoutPostTreatment )
        .value( "AutomaticPostTreatment", AutomaticPostTreatment )
        .value( "ForcedPostTreatment", ForcedPostTreatment )
        .value( "MinimalPostTreatment", MinimalPostTreatment );

    py::enum_< MumpsAcceleration >( "MumpsAcceleration" )
        .value( "AutomaticAcceleration", AutomaticAcceleration )
        .value( "FullRank", FullRank )
        .value( "FullRankPlus", FullRankPlus )
        .value( "LowRank", LowRank )
        .value( "LowRankPlus", LowRankPlus );

    py::class_< BaseLinearSolverClass, BaseLinearSolverClass::BaseLinearSolverPtr,
                py::bases< DataStructure > >( "BaseLinearSolver", py::no_init )
        .def( "build", &BaseLinearSolverClass::build )
        .def( "solveRealLinearSystem", &BaseLinearSolverClass::solveRealLinearSystem,
              solveRealLinearSystem_overloads() )
        .def( "solveRealLinearSystemWithKinematicsLoad",
              &BaseLinearSolverClass::solveRealLinearSystemWithKinematicsLoad,
              solveRealLinearSystemWithKinematicsLoad_overloads() )
        .def( "disablePreprocessing", &BaseLinearSolverClass::disablePreprocessing )
        .def( "matrixFactorization", &BaseLinearSolverClass::matrixFactorization )
        .def( "setAlgorithm", &BaseLinearSolverClass::setAlgorithm )
        .def( "setDistributedMatrix", &BaseLinearSolverClass::setDistributedMatrix )
        .def( "setErrorOnMatrixSingularity",
              &BaseLinearSolverClass::setErrorOnMatrixSingularity )
        .def( "setFilling", &BaseLinearSolverClass::setFilling )
        .def( "setFillingLevel", &BaseLinearSolverClass::setFillingLevel )
        .def( "setLagrangeElimination", &BaseLinearSolverClass::setLagrangeElimination )
        .def( "setLowRankSize", &BaseLinearSolverClass::setLowRankSize )
        .def( "setLowRankThreshold", &BaseLinearSolverClass::setLowRankThreshold )
        .def( "setMatrixFilter", &BaseLinearSolverClass::setMatrixFilter )
        .def( "setMatrixType", &BaseLinearSolverClass::setMatrixType )
        .def( "setMaximumNumberOfIteration",
              &BaseLinearSolverClass::setMaximumNumberOfIteration )
        .def( "setMemoryManagement", &BaseLinearSolverClass::setMemoryManagement )
        .def( "setPivotingMemory", &BaseLinearSolverClass::setPivotingMemory )
        .def( "setPrecisionMix", &BaseLinearSolverClass::setPrecisionMix )
        .def( "setPreconditioning", &BaseLinearSolverClass::setPreconditioning )
        .def( "setPreconditioningResidual", &BaseLinearSolverClass::setPreconditioningResidual )
        .def( "setSingularityDetectionThreshold",
              &BaseLinearSolverClass::setSingularityDetectionThreshold )
        .def( "setSolverResidual", &BaseLinearSolverClass::setSolverResidual )
        .def( "setPetscOption", &BaseLinearSolverClass::setPetscOption )
        .def( "setUpdatePreconditioningParameter",
              &BaseLinearSolverClass::setUpdatePreconditioningParameter );

    py::class_< MultFrontSolverClass, MultFrontSolverPtr,
                py::bases< BaseLinearSolverClass > >( "MultFrontSolver", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< MultFrontSolverClass >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< MultFrontSolverClass, std::string >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< MultFrontSolverClass, Renumbering >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< MultFrontSolverClass, std::string, Renumbering >));

    py::class_< LdltSolverClass, LdltSolverPtr, py::bases< BaseLinearSolverClass > >(
        "LdltSolver", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< LdltSolverClass >))
        .def( "__init__", py::make_constructor(&initFactoryPtr< LdltSolverClass, std::string >))
        .def( "__init__", py::make_constructor(&initFactoryPtr< LdltSolverClass, Renumbering >))
        .def( "__init__", py::make_constructor(
                              &initFactoryPtr< LdltSolverClass, std::string, Renumbering >));

    py::class_< MumpsSolverClass, MumpsSolverPtr, py::bases< BaseLinearSolverClass > >(
        "MumpsSolver", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< MumpsSolverClass >))
        .def( "__init__", py::make_constructor(&initFactoryPtr< MumpsSolverClass, std::string >))
        .def( "__init__", py::make_constructor(&initFactoryPtr< MumpsSolverClass, Renumbering >))
        .def( "__init__", py::make_constructor(
                              &initFactoryPtr< MumpsSolverClass, std::string, Renumbering >))
        .def( "setAcceleration", &BaseLinearSolverClass::setAcceleration )
        .def( "setPostTreatment", &BaseLinearSolverClass::setPostTreatment );

    py::class_< PetscSolverClass, PetscSolverPtr, py::bases< BaseLinearSolverClass > >(
        "PetscSolver", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< PetscSolverClass >))
        .def( "__init__", py::make_constructor(&initFactoryPtr< PetscSolverClass, std::string >))
        .def( "__init__", py::make_constructor(&initFactoryPtr< PetscSolverClass, Renumbering >))
        .def( "__init__", py::make_constructor(
                              &initFactoryPtr< PetscSolverClass, std::string, Renumbering >));

    py::class_< GcpcSolverClass, GcpcSolverPtr, py::bases< BaseLinearSolverClass > >(
        "GcpcSolver", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< GcpcSolverClass >))
        .def( "__init__", py::make_constructor(&initFactoryPtr< GcpcSolverClass, std::string >))
        .def( "__init__", py::make_constructor(&initFactoryPtr< GcpcSolverClass, Renumbering >))
        .def( "__init__", py::make_constructor(
                              &initFactoryPtr< GcpcSolverClass, std::string, Renumbering >));
};
