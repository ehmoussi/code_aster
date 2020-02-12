/**
 * @file GeneralizedResultInterface.cxx
 * @brief Interface python de GeneralizedResult
 * @author Natacha Béreux
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
#include "PythonBindings/GeneralizedResultInterface.h"


void exportGeneralizedResultToPython()
{


    py::class_< GeneralizedResultRealClass,
            GeneralizedResultRealPtr,
            py::bases< DataStructure > >
            ( "GeneralizedResultReal", py::no_init )
        // fake initFactoryPtr: created by subclasses
        // fake initFactoryPtr: created by subclasses
    ;

    py::class_< GeneralizedResultComplexClass,
            GeneralizedResultComplexPtr,
            py::bases< DataStructure > >
            ( "GeneralizedResultComplex", py::no_init )
        // fake initFactoryPtr: created by subclasses
        // fake initFactoryPtr: created by subclasses
    ;

    py::class_< TransientGeneralizedResultClass,
            TransientGeneralizedResultPtr,
            py::bases< GeneralizedResultRealClass > >
            ( "TransientGeneralizedResult", py::no_init )
        .def( "__init__", py::make_constructor(
            &initFactoryPtr< TransientGeneralizedResultClass >) )
        .def( "__init__", py::make_constructor(
            &initFactoryPtr< TransientGeneralizedResultClass,
                             std::string >) )
        .def( "setGeneralizedDOFNumbering",
              &TransientGeneralizedResultClass::setGeneralizedDOFNumbering )
        .def( "getGeneralizedDOFNumbering",
              &TransientGeneralizedResultClass::getGeneralizedDOFNumbering )
        .def( "setDOFNumbering",
              &TransientGeneralizedResultClass::setDOFNumbering )
        .def( "getDOFNumbering",
              &TransientGeneralizedResultClass::getDOFNumbering )
    ;

    py::class_< HarmoGeneralizedResultClass,
            HarmoGeneralizedResultPtr,
            py::bases< GeneralizedResultComplexClass > >
            ( "HarmoGeneralizedResult", py::no_init )
        .def( "__init__", py::make_constructor(
            &initFactoryPtr< HarmoGeneralizedResultClass >) )
        .def( "__init__", py::make_constructor(
            &initFactoryPtr< HarmoGeneralizedResultClass,
                             std::string >) )
        .def( "getGeneralizedDOFNumbering",
              &HarmoGeneralizedResultClass::getGeneralizedDOFNumbering )
        .def( "setGeneralizedDOFNumbering",
              &HarmoGeneralizedResultClass::setGeneralizedDOFNumbering )
        .def( "setDOFNumbering",
              &HarmoGeneralizedResultClass::setDOFNumbering )
        .def( "getDOFNumbering",
              &HarmoGeneralizedResultClass::getDOFNumbering )
    ;
};
