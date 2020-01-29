/**
 * @file StaticModeAnalysisInterface.cxx
 * @brief Interface python de StaticModeAnalysis
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

#include "PythonBindings/StaticModeAnalysisInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

namespace py = boost::python;

void exportStaticModeAnalysisToPython() {

    py::class_< StaticModeDeplClass, StaticModeDeplPtr >( "StaticModeDepl", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< StaticModeDeplClass >))
        // fake initFactoryPtr: not a DataStructure
        .def( "setMassMatrix", &StaticModeDeplClass::setMassMatrix )
        .def( "setStiffMatrix", &StaticModeDeplClass::setStiffMatrix )
        .def( "setLinearSolver", &StaticModeDeplClass::setLinearSolver )
        .def( "enableOnAllMesh", &StaticModeDeplClass::enableOnAllMesh )
        .def( "setAllComponents", &StaticModeDeplClass::setAllComponents )
        .def( "WantedGroupOfNodes", &StaticModeDeplClass::WantedGroupOfNodes )
        .def( "UnwantedComponent", &StaticModeDeplClass::UnwantedComponent )
        .def( "WantedComponent", &StaticModeDeplClass::WantedComponent )
        .def( "execute", &StaticModeDeplClass::execute );

    py::class_< StaticModeForcClass, StaticModeForcPtr >( "StaticModeForc", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< StaticModeForcClass >))
        // fake initFactoryPtr: not a DataStructure
        .def( "setMassMatrix", &StaticModeForcClass::setMassMatrix )
        .def( "setStiffMatrix", &StaticModeForcClass::setStiffMatrix )
        .def( "setLinearSolver", &StaticModeForcClass::setLinearSolver )
        .def( "enableOnAllMesh", &StaticModeForcClass::enableOnAllMesh )
        .def( "setAllComponents", &StaticModeForcClass::setAllComponents )
        .def( "WantedGroupOfNodes", &StaticModeForcClass::WantedGroupOfNodes )
        .def( "UnwantedComponent", &StaticModeForcClass::UnwantedComponent )
        .def( "WantedComponent", &StaticModeForcClass::WantedComponent )
        .def( "execute", &StaticModeForcClass::execute );

    py::class_< StaticModePseudoClass, StaticModePseudoPtr >( "StaticModePseudo", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< StaticModePseudoClass >))
        // fake initFactoryPtr: not a DataStructure
        .def( "setMassMatrix", &StaticModePseudoClass::setMassMatrix )
        .def( "setStiffMatrix", &StaticModePseudoClass::setStiffMatrix )
        .def( "setLinearSolver", &StaticModePseudoClass::setLinearSolver )
        .def( "enableOnAllMesh", &StaticModePseudoClass::enableOnAllMesh )
        .def( "setAllComponents", &StaticModePseudoClass::setAllComponents )
        .def( "WantedGroupOfNodes", &StaticModePseudoClass::WantedGroupOfNodes )
        .def( "WantedDirection", &StaticModePseudoClass::WantedDirection )
        .def( "setNameForDirection", &StaticModePseudoClass::setNameForDirection )
        .def( "WantedAxe", &StaticModePseudoClass::WantedAxe )
        .def( "UnwantedComponent", &StaticModePseudoClass::UnwantedComponent )
        .def( "WantedComponent", &StaticModePseudoClass::WantedComponent )
        .def( "execute", &StaticModePseudoClass::execute );

    py::class_< StaticModeInterfClass, StaticModeInterfPtr >( "StaticModeInterf", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< StaticModeInterfClass >))
        // fake initFactoryPtr: not a DataStructure
        .def( "setMassMatrix", &StaticModeInterfClass::setMassMatrix )
        .def( "setStiffMatrix", &StaticModeInterfClass::setStiffMatrix )
        .def( "setLinearSolver", &StaticModeInterfClass::setLinearSolver )
        .def( "enableOnAllMesh", &StaticModeInterfClass::enableOnAllMesh )
        .def( "setAllComponents", &StaticModeInterfClass::setAllComponents )
        .def( "WantedGroupOfNodes", &StaticModeInterfClass::WantedGroupOfNodes )
        .def( "UnwantedComponent", &StaticModeInterfClass::UnwantedComponent )
        .def( "WantedComponent", &StaticModeInterfClass::WantedComponent )
        .def( "setNumberOfModes", &StaticModeInterfClass::setNumberOfModes )
        .def( "setShift", &StaticModeInterfClass::setShift )
        .def( "execute", &StaticModeInterfClass::execute );
};
