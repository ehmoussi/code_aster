/**
 * @file FieldOnElementsInterface.cxx
 * @brief Interface python de FieldOnElements
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

#include "PythonBindings/DataStructureInterface.h"
#include "PythonBindings/FieldOnElementsInterface.h"

void exportFieldOnElementsToPython() {
    py::class_< FieldOnElementsDoubleClass, FieldOnElementsDoublePtr,
            py::bases< GenericDataFieldClass > >( "FieldOnElementsDouble", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< FieldOnElementsDoubleClass >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< FieldOnElementsDoubleClass, std::string >))
        .def( "exportToSimpleFieldOnElements",
              &FieldOnElementsDoubleClass::exportToSimpleFieldOnElements )
        .def( "getModel", &FieldOnElementsDoubleClass::getModel )
        .def( "setDescription", &FieldOnElementsDoubleClass::setDescription )
        .def( "setModel", &FieldOnElementsDoubleClass::setModel )
        .def( "update", &FieldOnElementsDoubleClass::update );
};
