/**
 * @file LibAster.cxx
 * @brief Création de LibAster
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2017  EDF R&D                www.code-aster.org
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

#include "PythonBindings/VectorUtilities.h"
#include "PythonBindings/DataStructureInterface.h"
#include "PythonBindings/DiscreteProblemInterface.h"
#include "PythonBindings/DOFNumberingInterface.h"
#include "PythonBindings/ElementaryCharacteristicsInterface.h"
#include "PythonBindings/FiberGeometryInterface.h"
#include "PythonBindings/FieldOnElementsInterface.h"
#include "PythonBindings/FieldOnNodesInterface.h"
#include "PythonBindings/MeshInterface.h"
#include "PythonBindings/PCFieldOnMeshInterface.h"
#include "PythonBindings/SimpleFieldOnElementsInterface.h"
#include "PythonBindings/SimpleFieldOnNodesInterface.h"
#include "PythonBindings/TableInterface.h"
#include "PythonBindings/TimeStepperInterface.h"
#include "PythonBindings/GeneralizedDOFNumberingInterface.h"
#include "PythonBindings/FluidStructureInteractionInterface.h"
#include "PythonBindings/TurbulentSpectrumInterface.h"
#include "PythonBindings/FunctionInterface.h"
#include "PythonBindings/SurfaceInterface.h"
#include "PythonBindings/ContactDefinitionInterface.h"
#include "PythonBindings/ContactZoneInterface.h"
#include "PythonBindings/XfemContactZoneInterface.h"
#include "PythonBindings/AssemblyMatrixInterface.h"
#include "PythonBindings/ElementaryMatrixInterface.h"
#include "PythonBindings/ElementaryVectorInterface.h"
#include "PythonBindings/GeneralizedAssemblyMatrixInterface.h"
#include "PythonBindings/GeneralizedAssemblyVectorInterface.h"
#include "PythonBindings/InterspectralMatrixInterface.h"
#include "PythonBindings/LinearSolverInterface.h"
#include "PythonBindings/ModalBasisDefinitionInterface.h"
#include "PythonBindings/StructureInterfaceInterface.h"
#include "PythonBindings/AcousticsLoadInterface.h"
#include "PythonBindings/KinematicsLoadInterface.h"
#include "PythonBindings/MechanicalLoadInterface.h"
#include "PythonBindings/PhysicalQuantityInterface.h"
#include "PythonBindings/ThermalLoadInterface.h"

using namespace boost::python;

BOOST_PYTHON_MODULE(libaster)
{
    exportVectorUtilitiesToPython();
    exportDataStructureToPython();
    exportMeshToPython();
    exportDiscreteProblemToPython();
    exportDOFNumberingToPython();
    exportElementaryCharacteristicsToPython();
    exportFiberGeometryToPython();
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
    exportFunctionToPython();
    exportSurfaceToPython();
    exportContactDefinitionToPython();
    exportContactZoneToPython();
    exportXfemContactZoneToPython();
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
    exportPhysicalQuantityToPython();
    exportThermalLoadToPython();
};
