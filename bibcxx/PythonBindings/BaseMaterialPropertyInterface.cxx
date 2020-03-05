/**
 * @file MaterialPropertyInterface.cxx
 * @brief Interface python de MaterialProperty
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

// Not DataStructures
// aslint: disable=C3006
#include "PythonBindings/BaseMaterialPropertyInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

namespace py = boost::python;

void exportBaseMaterialPropertyToPython() {

    py::class_< BaseMaterialPropertyClass, BaseMaterialPropertyPtr >(
        "BaseMaterialProperty", py::no_init )
        // fake initFactoryPtr: created by subclasses
        .def( "__init__", py::make_constructor(&initFactoryPtr< BaseMaterialPropertyClass >))
        .def( "getAsterName", &BaseMaterialPropertyClass::getAsterName )
        .def( "hasTractionFunction", &BaseMaterialPropertyClass::hasTractionFunction )
        .def( "hasEnthalpyFunction", &BaseMaterialPropertyClass::hasEnthalpyFunction )
        .def( "getComplexValue", &BaseMaterialPropertyClass::getComplexValue )
        .def( "getRealValue", &BaseMaterialPropertyClass::getRealValue )
        .def( "getStringValue", &BaseMaterialPropertyClass::getStringValue )
        .def( "getGenericFunctionValue",
              &BaseMaterialPropertyClass::getGenericFunctionValue )
        .def( "getNumberOfListOfRealProperties",
              &BaseMaterialPropertyClass::getNumberOfListOfRealProperties )
        .def( "getNumberOfListOfFunctionProperties",
              &BaseMaterialPropertyClass::getNumberOfListOfFunctionProperties )
        .def( "getTableValue", &BaseMaterialPropertyClass::getTableValue )
        .def( "hasComplexValue", &BaseMaterialPropertyClass::hasComplexValue )
        .def( "hasRealValue", &BaseMaterialPropertyClass::hasRealValue )
        .def( "hasStringValue", &BaseMaterialPropertyClass::hasStringValue )
        .def( "hasGenericFunctionValue",
              &BaseMaterialPropertyClass::hasGenericFunctionValue )
        .def( "hasTableValue", &BaseMaterialPropertyClass::hasTableValue )
        .def( "setComplexValue", &BaseMaterialPropertyClass::setComplexValue )
        .def( "setRealValue", &BaseMaterialPropertyClass::setRealValue )
        .def( "setStringValue", &BaseMaterialPropertyClass::setStringValue )
        .def( "setFunctionValue", &BaseMaterialPropertyClass::setFunctionValue )
        .def( "setTableValue", &BaseMaterialPropertyClass::setTableValue )
        .def( "setSurfaceValue", &BaseMaterialPropertyClass::setSurfaceValue )
        .def( "setFormulaValue", &BaseMaterialPropertyClass::setFormulaValue )
        .def( "setVectorOfRealValue", &BaseMaterialPropertyClass::setVectorOfRealValue )
        .def( "setVectorOfFunctionValue",
              &BaseMaterialPropertyClass::setVectorOfFunctionValue )
        .def( "setSortedListParameters",
              &BaseMaterialPropertyClass::setSortedListParameters );

};
