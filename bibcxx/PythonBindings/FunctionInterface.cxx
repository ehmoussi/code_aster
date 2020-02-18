/**
 * @file FunctionInterface.cxx
 * @brief Interface python de Function
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

#include "PythonBindings/FunctionInterface.h"
#include "PythonBindings/factory.h"

void exportFunctionToPython() {

    py::class_< BaseFunctionClass, BaseFunctionClass::BaseFunctionPtr,
                py::bases< GenericFunctionClass > >( "BaseFunction", py::no_init )
        // fake initFactoryPtr: created by subclasses
        // fake initFactoryPtr: created by subclasses
        .def( "setParameterName", &FunctionClass::setParameterName )
        .def( "setResultName", &FunctionClass::setResultName )
        .def( "setInterpolation", &FunctionClass::setInterpolation )
        .def( "setValues", &FunctionClass::setValues )
        .def( "getValues", &FunctionClass::getValues );

    py::class_< FunctionClass, FunctionClass::FunctionPtr,
                py::bases< BaseFunctionClass > >( "Function", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< FunctionClass >))
        .def( "__init__", py::make_constructor(&initFactoryPtr< FunctionClass, std::string >))
        .def( "setValues", &FunctionClass::setValues )
        .def( "size", &FunctionClass::size )
        .def( "setAsConstant", &FunctionClass::setAsConstant );

    // Candidates for setValues
    void ( FunctionComplexClass::*c1 )( const VectorReal &absc, const VectorReal &ord ) =
        &FunctionComplexClass::setValues;
    void ( FunctionComplexClass::*c2 )( const VectorReal &absc, const VectorComplex &ord ) =
        &FunctionComplexClass::setValues;

    py::class_< FunctionComplexClass, FunctionComplexClass::FunctionComplexPtr,
                py::bases< BaseFunctionClass > >( "FunctionComplex", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< FunctionComplexClass >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< FunctionComplexClass, std::string >))
        .def( "setValues", c1 )
        .def( "setValues", c2 )
        .def( "size", &FunctionComplexClass::size );
};
