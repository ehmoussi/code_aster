/**
 * @file AcousticsLoadInterface.cxx
 * @brief Interface python de AcousticsLoad
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

#include <boost/python.hpp>

namespace py = boost::python;
#include <PythonBindings/factory.h>
#include "PythonBindings/AcousticsLoadInterface.h"

void exportAcousticsLoadToPython() {

    py::class_< AcousticsLoadInstance, AcousticsLoadInstance::AcousticsLoadPtr,
            py::bases< DataStructure > >( "AcousticsLoad", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< AcousticsLoadInstance, ModelPtr >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< AcousticsLoadInstance, std::string, ModelPtr >))
        .def( "addImposedNormalSpeedOnAllMesh",
              &AcousticsLoadInstance::addImposedNormalSpeedOnAllMesh )
        .def( "addImposedNormalSpeedOnGroupsOfElements",
              &AcousticsLoadInstance::addImposedNormalSpeedOnGroupsOfElements )
        .def( "addImpedanceOnAllMesh", &AcousticsLoadInstance::addImpedanceOnAllMesh )
        .def( "addImpedanceOnGroupsOfElements",
              &AcousticsLoadInstance::addImpedanceOnGroupsOfElements )
        .def( "addImposedPressureOnAllMesh", &AcousticsLoadInstance::addImposedPressureOnAllMesh )
        .def( "addImposedPressureOnGroupsOfElements",
              &AcousticsLoadInstance::addImposedPressureOnGroupsOfElements )
        .def( "addImposedPressureOnGroupsOfNodes",
              &AcousticsLoadInstance::addImposedPressureOnGroupsOfNodes )
        .def( "addUniformConnectionOnGroupsOfElements",
              &AcousticsLoadInstance::addUniformConnectionOnGroupsOfElements )
        .def( "addUniformConnectionOnGroupsOfNodes",
              &AcousticsLoadInstance::addUniformConnectionOnGroupsOfNodes )
        .def( "build", &AcousticsLoadInstance::build )
        .def( "getFiniteElementDescriptor", &AcousticsLoadInstance::getFiniteElementDescriptor )
        .def( "getModel", &AcousticsLoadInstance::getModel );
};
