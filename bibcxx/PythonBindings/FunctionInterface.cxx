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

    py::class_< BaseFunctionInstance, BaseFunctionInstance::BaseFunctionPtr,
                py::bases< GenericFunctionInstance > >( "BaseFunction", py::no_init )
        // fake initFactoryPtr: created by subclasses
        // fake initFactoryPtr: created by subclasses
        .def( "setParameterName", &FunctionInstance::setParameterName )
        .def( "setResultName", &FunctionInstance::setResultName )
        .def( "setInterpolation", &FunctionInstance::setInterpolation )
        .def( "setValues", &FunctionInstance::setValues )
        .def( "getValues", &FunctionInstance::getValues );

    py::class_< FunctionInstance, FunctionInstance::FunctionPtr,
                py::bases< BaseFunctionInstance > >( "Function", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< FunctionInstance >))
        .def( "__init__", py::make_constructor(&initFactoryPtr< FunctionInstance, std::string >))
        .def( "setValues", &FunctionInstance::setValues )
        .def( "size", &FunctionInstance::size )
        .def( "setAsConstant", &FunctionInstance::setAsConstant );

    // Candidates for setValues
    void ( FunctionComplexInstance::*c1 )( const VectorDouble &absc, const VectorDouble &ord ) =
        &FunctionComplexInstance::setValues;
    void ( FunctionComplexInstance::*c2 )( const VectorDouble &absc, const VectorComplex &ord ) =
        &FunctionComplexInstance::setValues;

    py::class_< FunctionComplexInstance, FunctionComplexInstance::FunctionComplexPtr,
                py::bases< BaseFunctionInstance > >( "FunctionComplex", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< FunctionComplexInstance >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< FunctionComplexInstance, std::string >))
        .def( "setValues", c1 )
        .def( "setValues", c2 )
        .def( "size", &FunctionComplexInstance::size );
};
