/**
 * @file LibAster.cxx
 * @brief Création de LibAster
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2018  EDF R&D                www.code-aster.org
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

#include <boost/python.hpp>

#include "astercxx.h"

#include "PythonBindings/AcousticModeContainerInterface.h"
#include "PythonBindings/AcousticsLoadInterface.h"
#include "PythonBindings/AssemblyMatrixInterface.h"
#include "PythonBindings/BehaviourDefinitionInterface.h"
#include "PythonBindings/BehaviourInterface.h"
#include "PythonBindings/BucklingModeContainerInterface.h"
#include "PythonBindings/ContactDefinitionInterface.h"
#include "PythonBindings/CppToFortranGlossaryInterface.h"
#include "PythonBindings/CrackShapeInterface.h"
#include "PythonBindings/CrackTipInterface.h"
#include "PythonBindings/CyclicSymmetryModeInterface.h"
#include "PythonBindings/DOFNumberingInterface.h"
#include "PythonBindings/DataStructureInterface.h"
#include "PythonBindings/DiscreteProblemInterface.h"
#include "PythonBindings/DrivingInterface.h"
#include "PythonBindings/DynamicMacroElementInterface.h"
#include "PythonBindings/ElasticEvolutionContainerInterface.h"
#include "PythonBindings/ElementaryCharacteristicsInterface.h"
#include "PythonBindings/ElementaryMatrixInterface.h"
#include "PythonBindings/ElementaryVectorInterface.h"
#include "PythonBindings/EvolutiveLoadInterface.h"
#include "PythonBindings/EvolutiveThermalLoadInterface.h"
#include "PythonBindings/FailureConvergenceManagerInterface.h"
#include "PythonBindings/FiberGeometryInterface.h"
#include "PythonBindings/FieldOnElementsInterface.h"
#include "PythonBindings/FieldOnNodesInterface.h"
#include "PythonBindings/FiniteElementDescriptorInterface.h"
#include "PythonBindings/FluidStructureInteractionInterface.h"
#include "PythonBindings/FluidStructureModalBasisInterface.h"
#include "PythonBindings/FormulaInterface.h"
#include "PythonBindings/FourierCombinationInterface.h"
#include "PythonBindings/FourierElasContainerInterface.h"
#include "PythonBindings/FourierTherContainerInterface.h"
#include "PythonBindings/FullAcousticHarmonicResultsContainerInterface.h"
#include "PythonBindings/FullHarmonicResultsContainerInterface.h"
#include "PythonBindings/FullResultsContainerInterface.h"
#include "PythonBindings/FullTransientResultsContainerInterface.h"
#include "PythonBindings/FunctionInterface.h"
#include "PythonBindings/GeneralizedAssemblyMatrixInterface.h"
#include "PythonBindings/GeneralizedAssemblyVectorInterface.h"
#include "PythonBindings/GeneralizedDOFNumberingInterface.h"
#include "PythonBindings/GeneralizedModeContainerInterface.h"
#include "PythonBindings/GeneralizedModelInterface.h"
#include "PythonBindings/GeneralizedResultsContainerInterface.h"
#include "PythonBindings/GenericDataFieldInterface.h"
#include "PythonBindings/GenericFunctionInterface.h"
#include "PythonBindings/GridInterface.h"
#include "PythonBindings/InputVariableDefinitionInterface.h"
#include "PythonBindings/InputVariableEvolutionContainerInterface.h"
#include "PythonBindings/InterspectralMatrixInterface.h"
#include "PythonBindings/KinematicsLoadInterface.h"
#include "PythonBindings/LineSearchMethodInterface.h"
#include "PythonBindings/LinearDisplacementEvolutionContainerInterface.h"
#include "PythonBindings/LinearSolverInterface.h"
#include "PythonBindings/ListOfFloatsInterface.h"
#include "PythonBindings/ListOfIntegersInterface.h"
#include "PythonBindings/MPIInfosInterface.h"
#include "PythonBindings/MatchingMeshesInterface.h"
#include "PythonBindings/MaterialBehaviourInterface.h"
#include "PythonBindings/MaterialInterface.h"
#include "PythonBindings/MaterialOnMeshBuilderInterface.h"
#include "PythonBindings/MaterialOnMeshInterface.h"
#include "PythonBindings/MechanicalLoadInterface.h"
#include "PythonBindings/MechanicalModeContainerInterface.h"
#include "PythonBindings/MeshCoordinatesFieldInterface.h"
#include "PythonBindings/MeshInterface.h"
#include "PythonBindings/ModalBasisDefinitionInterface.h"
#include "PythonBindings/ModeEmpiContainerInterface.h"
#include "PythonBindings/ModelInterface.h"
#include "PythonBindings/MultElasContainerInterface.h"
#include "PythonBindings/NonLinearEvolutionContainerInterface.h"
#include "PythonBindings/NonLinearMethodInterface.h"
#include "PythonBindings/NormalModeAnalysisInterface.h"
#include "PythonBindings/PCFieldOnMeshInterface.h"
#include "PythonBindings/ParallelDOFNumberingInterface.h"
#include "PythonBindings/ParallelMechanicalLoadInterface.h"
#include "PythonBindings/ParallelMeshInterface.h"
#include "PythonBindings/PartialMeshInterface.h"
#include "PythonBindings/PhysicalQuantityInterface.h"
#include "PythonBindings/PhysicsAndModelingsInterface.h"
#include "PythonBindings/PrestressingCableDefinitionInterface.h"
#include "PythonBindings/ResultNamingInterface.h"
#include "PythonBindings/ResultsContainerInterface.h"
#include "PythonBindings/SimpleFieldOnElementsInterface.h"
#include "PythonBindings/SimpleFieldOnNodesInterface.h"
#include "PythonBindings/SkeletonInterface.h"
#include "PythonBindings/StateInterface.h"
#include "PythonBindings/StaticMacroElementInterface.h"
#include "PythonBindings/StaticMechanicalSolverInterface.h"
#include "PythonBindings/StaticModeAnalysisInterface.h"
#include "PythonBindings/StaticNonLinearAnalysisInterface.h"
#include "PythonBindings/StructureInterfaceInterface.h"
#include "PythonBindings/StudyDescriptionInterface.h"
#include "PythonBindings/SurfaceInterface.h"
#include "PythonBindings/TableInterface.h"
#include "PythonBindings/ThermalLoadInterface.h"
#include "PythonBindings/TimeDependantResultsContainerInterface.h"
#include "PythonBindings/TimeStepManagerInterface.h"
#include "PythonBindings/TimeStepperInterface.h"
#include "PythonBindings/TurbulentSpectrumInterface.h"
#include "PythonBindings/UnitaryThermalLoadInterface.h"
#include "PythonBindings/VectorUtilities.h"
#include "PythonBindings/XfemCrackInterface.h"

#include "RunManager/Exceptions.h"

#include "aster_fort.h"
#include "aster_init.h"
#include "shared_vars.h"

namespace py = boost::python;

static void libaster_finalize() {
    if ( get_sh_jeveux_status() != 1 )
        return;
    CALL_OP9999();
    register_sh_jeveux_status( 0 );
};

static void libaster_debugJeveuxContent( const std::string message ) {
    ASTERINTEGER unit_out = 6;
    std::string base( "G" );
    CALLO_JEIMPR( &unit_out, base, message );
};

struct LibAsterInitializer {
    LibAsterInitializer() { initAsterModules(); };

    ~LibAsterInitializer() { libaster_finalize(); };
};

PyObject *AsterErrorPy = (PyObject *)0;

void translateAsterError( AsterErrorCpp const &exc ) {
    assert( AsterErrorPy != NULL );

    PyObject *py_err = exc.py_attrs();
    PyErr_SetObject( AsterErrorPy, py_err );
    Py_DECREF( py_err );
}

BOOST_PYTHON_FUNCTION_OVERLOADS( raiseAsterError_overloads, raiseAsterError, 0, 1 )

BOOST_PYTHON_MODULE( libaster ) {
    // hide c++ signatures
    py::docstring_options doc_options( true, true, false );

    boost::shared_ptr< LibAsterInitializer > libGuard( new LibAsterInitializer() );

    py::class_< LibAsterInitializer, boost::shared_ptr< LibAsterInitializer >, boost::noncopyable >(
        "LibAsterInitializer", py::no_init );

    py::scope().attr( "__libguard" ) = libGuard;
    py::scope().attr( "finalize" ) = &libaster_finalize;
    py::scope().attr( "debugJeveuxContent" ) = &libaster_debugJeveuxContent;

    // Exceptions
    AsterErrorPy = createExceptionClass( "AsterError" );
    py::register_exception_translator< AsterErrorCpp >( &translateAsterError );

    py::def( "raiseAsterError", &raiseAsterError, raiseAsterError_overloads() );

    exportVectorUtilitiesToPython();
    exportDataStructureToPython();
    exportMeshToPython();
    exportDiscreteProblemToPython();
    exportDOFNumberingToPython();
    exportElementaryCharacteristicsToPython();
    exportFiniteElementDescriptorToPython();
    exportFiberGeometryToPython();
    exportGenericDataFieldToPython();
    exportFieldOnElementsToPython();
    exportFieldOnNodesToPython();
    exportPCFieldOnMeshToPython();
    exportSimpleFieldOnElementsToPython();
    exportSimpleFieldOnNodesToPython();
    exportTableToPython();
    exportTimeStepperToPython();
    exportGeneralizedDOFNumberingToPython();
    exportFluidStructureInteractionToPython();
    exportTurbulentSpectrumToPython();
    exportGenericFunctionToPython();
    exportFunctionToPython();
    exportFormulaToPython();
    exportSurfaceToPython();
    exportContactDefinitionToPython();
    exportAssemblyMatrixToPython();
    exportElementaryMatrixToPython();
    exportElementaryVectorToPython();
    exportGeneralizedAssemblyMatrixToPython();
    exportGeneralizedAssemblyVectorToPython();
    exportInterspectralMatrixToPython();
    exportLinearSolverToPython();
    exportModalBasisDefinitionToPython();
    exportStructureInterfaceToPython();
    exportAcousticsLoadToPython();
    exportKinematicsLoadToPython();
    exportMechanicalLoadToPython();
    exportPhysicalQuantityToPython();
    exportThermalLoadToPython();
    exportUnitaryThermalLoadToPython();
    exportBehaviourDefinitionToPython();
    exportMaterialToPython();
    exportMaterialBehaviourToPython();
    exportMaterialOnMeshToPython();
    exportGridToPython();
    exportMatchingMeshesToPython();
    exportSkeletonToPython();
    exportDynamicMacroElementToPython();
    exportStaticMacroElementToPython();
    exportCrackShapeToPython();
    exportCrackTipToPython();
    exportGeneralizedModelToPython();
    exportModelToPython();
    exportPhysicsAndModelingsToPython();
    exportPrestressingCableDefinitionToPython();
    exportXfemCrackToPython();
    exportBehaviourToPython();
    exportDrivingToPython();
    exportLineSearchMethodToPython();
    exportNonLinearMethodToPython();
    exportStateToPython();
    exportResultsContainerToPython();
    exportTimeDependantResultsContainerToPython();
    exportEvolutiveLoadToPython();
    exportEvolutiveThermalLoadToPython();
    exportFourierCombinationToPython();
    exportFourierElasContainerToPython();
    exportFourierTherContainerToPython();
    exportMultElasContainerToPython();
    exportNonLinearEvolutionContainerToPython();
    exportNormalModeAnalysisToPython();
    exportStaticMechanicalSolverToPython();
    exportStaticModeAnalysisToPython();
    exportStaticNonLinearAnalysisToPython();
    exportFailureConvergenceManagerToPython();
    exportStudyDescriptionToPython();
    exportTimeStepManagerToPython();
    exportCppToFortranGlossaryToPython();
    exportCyclicSymmetryModeToPython();
    exportFullResultsContainerToPython();
    exportMechanicalModeContainerToPython();
    exportMechanicalModeComplexContainerToPython();
    exportAcousticModeContainerToPython();
    exportBucklingModeContainerToPython();
    exportGeneralizedResultsContainerToPython();
    exportLinearDisplacementEvolutionContainerToPython();
    exportMeshCoordinatesFieldToPython();
    exportFullTransientResultsContainerToPython();
    exportFullHarmonicResultsContainerToPython();
    exportFullAcousticHarmonicResultsContainerToPython();
    exportFluidStructureModalBasisToPython();
    exportGeneralizedModeContainerToPython();

#ifdef _USE_MPI
    exportParallelMeshToPython();
    exportParallelDOFNumberingToPython();
    exportParallelMechanicalLoadToPython();
    exportMPIInfosToPython();
#endif /* _USE_MPI */

    exportPartialMeshToPython();
    exportResultNamingToPython();
    exportListOfFloatsToPython();
    exportListOfIntegersToPython();
    exportInputVariableDefinitionToPython();
    exportModeEmpiContainerToPython();
    exportElasticEvolutionContainerToPython();
    exportInputVariableEvolutionContainerToPython();
    exportMaterialOnMeshBuilderToPython();
};
