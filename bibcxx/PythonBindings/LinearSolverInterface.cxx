/**
 * @file LinearSolverInterface.cxx
 * @brief Interface python de LinearSolver
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
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
#include <PythonBindings/factory.h>
#include "PythonBindings/LinearSolverInterface.h"

BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( solveDoubleLinearSystemWithKinematicsLoad_overloads,
                                        solveDoubleLinearSystemWithKinematicsLoad, 3, 4 )
BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( solveDoubleLinearSystem_overloads, solveDoubleLinearSystem,
                                        2, 3 )

void exportLinearSolverToPython() {
    using namespace boost::python;

    enum_< LinearSolverEnum >( "BaseLinearSolverName" )
        .value( "MultFront", MultFront )
        .value( "Ldlt", Ldlt )
        .value( "Mumps", Mumps )
        .value( "Petsc", Petsc )
        .value( "Gcpc", Gcpc );

    enum_< Renumbering >( "Renumbering" )
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

    enum_< Preconditioning >( "Preconditioning" )
        .value( "IncompleteLdlt", IncompleteLdlt )
        .value( "SimplePrecisionLdlt", SimplePrecisionLdlt )
        .value( "Jacobi", Jacobi )
        .value( "Sor", Sor )
        .value( "Ml", Ml )
        .value( "Boomer", Boomer )
        .value( "Gamg", Gamg )
        .value( "LagrBloc", LagrBloc )
        .value( "Without", Without );

    enum_< IterativeSolverAlgorithm >( "IterativeSolverAlgorithm" )
        .value( "ConjugateGradiant", ConjugateGradiant )
        .value( "ConjugateResidual", ConjugateResidual )
        .value( "GMRes", GMRes )
        .value( "GCR", GCR )
        .value( "FGMRes", FGMRes );

    enum_< LagrangeTreatment >( "LagrangeTreatment" )
        .value( "Eliminate", Eliminate )
        .value( "NotEliminate", NotEliminate )
        .value( "DoubleLagrangeEliminate", DoubleLagrangeEliminate );

    enum_< MemoryManagement >( "MemoryManagement" )
        .value( "InCore", InCore )
        .value( "OutOfCore", OutOfCore )
        .value( "Automatic", Automatic )
        .value( "Evaluation", Evaluation );

    enum_< MatrixType >( "MatrixType" )
        .value( "NonSymetric", NonSymetric )
        .value( "Symetric", Symetric )
        .value( "SymetricPositiveDefinite", SymetricPositiveDefinite )
        .value( "Undefined", Undefined );

    enum_< MumpsPostTreatment >( "MumpsPostTreatment" )
        .value( "WithoutPostTreatment", WithoutPostTreatment )
        .value( "AutomaticPostTreatment", AutomaticPostTreatment )
        .value( "ForcedPostTreatment", ForcedPostTreatment )
        .value( "MinimalPostTreatment", MinimalPostTreatment );

    enum_< MumpsAcceleration >( "MumpsAcceleration" )
        .value( "AutomaticAcceleration", AutomaticAcceleration )
        .value( "FullRank", FullRank )
        .value( "FullRankPlus", FullRankPlus )
        .value( "LowRank", LowRank )
        .value( "LowRankPlus", LowRankPlus );

    class_< BaseLinearSolverInstance, BaseLinearSolverInstance::BaseLinearSolverPtr,
            bases< DataStructure > >( "BaseLinearSolver", no_init )
        .def( "build", &BaseLinearSolverInstance::build )
        .def( "solveDoubleLinearSystem", &BaseLinearSolverInstance::solveDoubleLinearSystem,
              solveDoubleLinearSystem_overloads() )
        .def( "solveDoubleLinearSystemWithKinematicsLoad",
              &BaseLinearSolverInstance::solveDoubleLinearSystemWithKinematicsLoad,
              solveDoubleLinearSystemWithKinematicsLoad_overloads() )
        .def( "disablePreprocessing", &BaseLinearSolverInstance::disablePreprocessing )
        .def( "matrixFactorization", &BaseLinearSolverInstance::matrixFactorization )
        .def( "setAlgorithm", &BaseLinearSolverInstance::setAlgorithm )
        .def( "setDistributedMatrix", &BaseLinearSolverInstance::setDistributedMatrix )
        .def( "setErrorOnMatrixSingularity",
              &BaseLinearSolverInstance::setErrorOnMatrixSingularity )
        .def( "setFilling", &BaseLinearSolverInstance::setFilling )
        .def( "setFillingLevel", &BaseLinearSolverInstance::setFillingLevel )
        .def( "setLagrangeElimination", &BaseLinearSolverInstance::setLagrangeElimination )
        .def( "setLowRankSize", &BaseLinearSolverInstance::setLowRankSize )
        .def( "setLowRankThreshold", &BaseLinearSolverInstance::setLowRankThreshold )
        .def( "setMatrixFilter", &BaseLinearSolverInstance::setMatrixFilter )
        .def( "setMatrixType", &BaseLinearSolverInstance::setMatrixType )
        .def( "setMaximumNumberOfIteration",
              &BaseLinearSolverInstance::setMaximumNumberOfIteration )
        .def( "setMemoryManagement", &BaseLinearSolverInstance::setMemoryManagement )
        .def( "setPivotingMemory", &BaseLinearSolverInstance::setPivotingMemory )
        .def( "setPrecisionMix", &BaseLinearSolverInstance::setPrecisionMix )
        .def( "setPreconditioning", &BaseLinearSolverInstance::setPreconditioning )
        .def( "setPreconditioningResidual", &BaseLinearSolverInstance::setPreconditioningResidual )
        .def( "setSingularityDetectionThreshold",
              &BaseLinearSolverInstance::setSingularityDetectionThreshold )
        .def( "setSolverResidual", &BaseLinearSolverInstance::setSolverResidual )
        .def( "setUpdatePreconditioningParameter",
              &BaseLinearSolverInstance::setUpdatePreconditioningParameter );

    class_< MultFrontSolverInstance, MultFrontSolverPtr, bases< BaseLinearSolverInstance > >(
        "MultFrontSolver", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< MultFrontSolverInstance >))
        .def( "__init__", make_constructor(&initFactoryPtr< MultFrontSolverInstance, std::string >))
        .def( "__init__", make_constructor(&initFactoryPtr< MultFrontSolverInstance, Renumbering >))
        .def(
            "__init__",
            make_constructor(&initFactoryPtr< MultFrontSolverInstance, std::string, Renumbering >));

    class_< LdltSolverInstance, LdltSolverPtr, bases< BaseLinearSolverInstance > >( "LdltSolver",
                                                                                    no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< LdltSolverInstance >))
        .def( "__init__", make_constructor(&initFactoryPtr< LdltSolverInstance, std::string >))
        .def( "__init__", make_constructor(&initFactoryPtr< LdltSolverInstance, Renumbering >))
        .def( "__init__",
              make_constructor(&initFactoryPtr< LdltSolverInstance, std::string, Renumbering >));

    class_< MumpsSolverInstance, MumpsSolverPtr, bases< BaseLinearSolverInstance > >( "MumpsSolver",
                                                                                      no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< MumpsSolverInstance >))
        .def( "__init__", make_constructor(&initFactoryPtr< MumpsSolverInstance, std::string >))
        .def( "__init__", make_constructor(&initFactoryPtr< MumpsSolverInstance, Renumbering >))
        .def( "__init__",
              make_constructor(&initFactoryPtr< MumpsSolverInstance, std::string, Renumbering >))
        .def( "setAcceleration", &BaseLinearSolverInstance::setAcceleration )
        .def( "setPostTreatment", &BaseLinearSolverInstance::setPostTreatment );

    class_< PetscSolverInstance, PetscSolverPtr, bases< BaseLinearSolverInstance > >( "PetscSolver",
                                                                                      no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< PetscSolverInstance >))
        .def( "__init__", make_constructor(&initFactoryPtr< PetscSolverInstance, std::string >))
        .def( "__init__", make_constructor(&initFactoryPtr< PetscSolverInstance, Renumbering >))
        .def( "__init__",
              make_constructor(&initFactoryPtr< PetscSolverInstance, std::string, Renumbering >));

    class_< GcpcSolverInstance, GcpcSolverPtr, bases< BaseLinearSolverInstance > >( "GcpcSolver",
                                                                                    no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< GcpcSolverInstance >))
        .def( "__init__", make_constructor(&initFactoryPtr< GcpcSolverInstance, std::string >))
        .def( "__init__", make_constructor(&initFactoryPtr< GcpcSolverInstance, Renumbering >))
        .def( "__init__",
              make_constructor(&initFactoryPtr< GcpcSolverInstance, std::string, Renumbering >));
};
