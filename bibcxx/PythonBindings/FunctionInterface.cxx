/**
 * @file FunctionInterface.cxx
 * @brief Interface python de Function
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include <boost/python.hpp>

#include "PythonBindings/factory.h"
#include "PythonBindings/FunctionInterface.h"


void exportFunctionToPython()
{
    using namespace boost::python;

    class_< BaseFunctionInstance, BaseFunctionInstance::BaseFunctionPtr,
            bases< GenericFunctionInstance > > ( "BaseFunction", no_init )
        .def( "setParameterName", &FunctionInstance::setParameterName )
        .def( "setResultName", &FunctionInstance::setResultName )
        .def( "setInterpolation", &FunctionInstance::setInterpolation )
        .def( "setExtrapolation", &FunctionInstance::setExtrapolation )
        .def( "setValues", &FunctionInstance::setValues )
        .def( "getProperties", &FunctionInstance::getProperties )
        .def( "getValues", &FunctionInstance::getValues )
    ;

    class_< FunctionInstance, FunctionInstance::FunctionPtr,
            bases< BaseFunctionInstance > > ( "Function", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< FunctionInstance >) )
        .def( "__init__", make_constructor(
            &initFactoryPtr< FunctionInstance,
                             std::string >) )
        .def( "setValues", &FunctionInstance::setValues )
        .def( "size", &FunctionInstance::size )
        .def( "setAsConstant", &FunctionInstance::setAsConstant )
    ;

    // Candidates for setValues
    void (FunctionComplexInstance::*c1)(const VectorDouble &absc, const VectorDouble &ord) =
        &FunctionComplexInstance::setValues;
    void (FunctionComplexInstance::*c2)(const VectorDouble &absc, const VectorComplex &ord) =
        &FunctionComplexInstance::setValues;

    class_< FunctionComplexInstance, FunctionComplexInstance::FunctionComplexPtr,
            bases< BaseFunctionInstance > > ( "FunctionComplex", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< FunctionComplexInstance >) )
        .def( "__init__", make_constructor(
            &initFactoryPtr< FunctionComplexInstance,
                             std::string >) )
        .def( "setValues", c1 )
        .def( "setValues", c2 )
        .def( "size", &FunctionComplexInstance::size )
    ;
};
