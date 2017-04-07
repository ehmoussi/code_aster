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

#include "PythonInterfaces/DataStructureInterface.h"
#include "PythonInterfaces/DiscreteProblemInterface.h"
#include "PythonInterfaces/DOFNumberingInterface.h"
#include "PythonInterfaces/ElementaryCharacteristicsInterface.h"
#include "PythonInterfaces/FiberGeometryInterface.h"
#include "PythonInterfaces/FieldOnElementsInterface.h"
#include "PythonInterfaces/FieldOnNodesInterface.h"
#include "PythonInterfaces/MeshInterface.h"
#include "PythonInterfaces/PCFieldOnMeshInterface.h"
#include "PythonInterfaces/SimpleFieldOnElementsInterface.h"
#include "PythonInterfaces/SimpleFieldOnNodesInterface.h"
#include "PythonInterfaces/TableInterface.h"
#include "PythonInterfaces/TimeStepperInterface.h"
#include "PythonInterfaces/VectorUtilities.h"
#include "PythonInterfaces/GeneralizedDOFNumberingInterface.h"
#include "PythonInterfaces/FluidStructureInteractionInterface.h"
#include "PythonInterfaces/TurbulentSpectrumInterface.h"
#include "PythonInterfaces/FunctionInterface.h"
#include "PythonInterfaces/SurfaceInterface.h"
#include "PythonInterfaces/ContactDefinitionInterface.h"
#include "PythonInterfaces/ContactZoneInterface.h"
#include "PythonInterfaces/XfemContactZoneInterface.h"
#include "PythonInterfaces/AssemblyMatrixInterface.h"
#include "PythonInterfaces/ElementaryMatrixInterface.h"

using namespace boost::python;

BOOST_PYTHON_MODULE(libaster)
{
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
};
