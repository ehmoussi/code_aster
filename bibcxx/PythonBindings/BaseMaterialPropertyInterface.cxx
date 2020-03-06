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

#include "PythonBindings/BaseMaterialPropertyInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

namespace py = boost::python;

void exportBaseMaterialPropertyToPython() {

    py::class_< GenericMaterialPropertyClass, BaseMaterialPropertyPtr >(
        "BaseMaterialProperty", py::no_init )
        // fake initFactoryPtr: created by subclasses
        .def( "__init__", py::make_constructor(&initFactoryPtr< GenericMaterialPropertyClass >))
        .def( "getAsterName", &GenericMaterialPropertyClass::getAsterName )
        .def( "hasTractionFunction", &GenericMaterialPropertyClass::hasTractionFunction )
        .def( "hasEnthalpyFunction", &GenericMaterialPropertyClass::hasEnthalpyFunction )
        .def( "getComplexValue", &GenericMaterialPropertyClass::getComplexValue )
        .def( "getRealValue", &GenericMaterialPropertyClass::getRealValue )
        .def( "getStringValue", &GenericMaterialPropertyClass::getStringValue )
        .def( "getGenericFunctionValue",
              &GenericMaterialPropertyClass::getGenericFunctionValue )
        .def( "getNumberOfListOfRealProperties",
              &GenericMaterialPropertyClass::getNumberOfListOfRealProperties )
        .def( "getNumberOfListOfFunctionProperties",
              &GenericMaterialPropertyClass::getNumberOfListOfFunctionProperties )
        .def( "getTableValue", &GenericMaterialPropertyClass::getTableValue )
        .def( "hasComplexValue", &GenericMaterialPropertyClass::hasComplexValue )
        .def( "hasRealValue", &GenericMaterialPropertyClass::hasRealValue )
        .def( "hasStringValue", &GenericMaterialPropertyClass::hasStringValue )
        .def( "hasGenericFunctionValue",
              &GenericMaterialPropertyClass::hasGenericFunctionValue )
        .def( "hasTableValue", &GenericMaterialPropertyClass::hasTableValue )
        .def( "setComplexValue", &GenericMaterialPropertyClass::setComplexValue )
        .def( "setRealValue", &GenericMaterialPropertyClass::setRealValue )
        .def( "setStringValue", &GenericMaterialPropertyClass::setStringValue )
        .def( "setFunctionValue", &GenericMaterialPropertyClass::setFunctionValue )
        .def( "setTableValue", &GenericMaterialPropertyClass::setTableValue )
        .def( "setFunction2DValue", &GenericMaterialPropertyClass::setFunction2DValue )
        .def( "setFormulaValue", &GenericMaterialPropertyClass::setFormulaValue )
        .def( "setVectorOfRealValue", &GenericMaterialPropertyClass::setVectorOfRealValue )
        .def( "setVectorOfFunctionValue",
              &GenericMaterialPropertyClass::setVectorOfFunctionValue )
        .def( "setSortedListParameters",
              &GenericMaterialPropertyClass::setSortedListParameters );

};
