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

    py::class_< AcousticsLoadClass, AcousticsLoadClass::AcousticsLoadPtr,
            py::bases< DataStructure > >( "AcousticsLoad", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< AcousticsLoadClass, ModelPtr >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< AcousticsLoadClass, std::string, ModelPtr >))
        .def( "addImposedNormalSpeedOnAllMesh",
              &AcousticsLoadClass::addImposedNormalSpeedOnAllMesh )
        .def( "addImposedNormalSpeedOnGroupsOfElements",
              &AcousticsLoadClass::addImposedNormalSpeedOnGroupsOfElements )
        .def( "addImpedanceOnAllMesh", &AcousticsLoadClass::addImpedanceOnAllMesh )
        .def( "addImpedanceOnGroupsOfElements",
              &AcousticsLoadClass::addImpedanceOnGroupsOfElements )
        .def( "addImposedPressureOnAllMesh", &AcousticsLoadClass::addImposedPressureOnAllMesh )
        .def( "addImposedPressureOnGroupsOfElements",
              &AcousticsLoadClass::addImposedPressureOnGroupsOfElements )
        .def( "addImposedPressureOnGroupsOfNodes",
              &AcousticsLoadClass::addImposedPressureOnGroupsOfNodes )
        .def( "addUniformConnectionOnGroupsOfElements",
              &AcousticsLoadClass::addUniformConnectionOnGroupsOfElements )
        .def( "addUniformConnectionOnGroupsOfNodes",
              &AcousticsLoadClass::addUniformConnectionOnGroupsOfNodes )
        .def( "build", &AcousticsLoadClass::build )
        .def( "getFiniteElementDescriptor", &AcousticsLoadClass::getFiniteElementDescriptor )
        .def( "getModel", &AcousticsLoadClass::getModel );
};
