/**
 * @file AcousticLoadInterface.cxx
 * @brief Interface python de AcousticLoad
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
#include "PythonBindings/AcousticLoadInterface.h"

void exportAcousticLoadToPython() {

    py::class_< AcousticLoadClass, AcousticLoadClass::AcousticLoadPtr,
            py::bases< DataStructure > >( "AcousticLoad", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< AcousticLoadClass, ModelPtr >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< AcousticLoadClass, std::string, ModelPtr >))
        .def( "addImposedNormalSpeedOnMesh",
              &AcousticLoadClass::addImposedNormalSpeedOnMesh )
        .def( "addImposedNormalSpeedOnGroupOfCells",
              &AcousticLoadClass::addImposedNormalSpeedOnGroupOfCells )
        .def( "addImpedanceOnMesh", &AcousticLoadClass::addImpedanceOnMesh )
        .def( "addImpedanceOnGroupOfCells",
              &AcousticLoadClass::addImpedanceOnGroupOfCells )
        .def( "addImposedPressureOnMesh", &AcousticLoadClass::addImposedPressureOnMesh )
        .def( "addImposedPressureOnGroupOfCells",
              &AcousticLoadClass::addImposedPressureOnGroupOfCells )
        .def( "addImposedPressureOnGroupOfNodes",
              &AcousticLoadClass::addImposedPressureOnGroupOfNodes )
        .def( "addUniformConnectionOnGroupOfCells",
              &AcousticLoadClass::addUniformConnectionOnGroupOfCells )
        .def( "addUniformConnectionOnGroupOfNodes",
              &AcousticLoadClass::addUniformConnectionOnGroupOfNodes )
        .def( "build", &AcousticLoadClass::build )
        .def( "getFiniteElementDescriptor", &AcousticLoadClass::getFiniteElementDescriptor )
        .def( "getModel", &AcousticLoadClass::getModel );
};
