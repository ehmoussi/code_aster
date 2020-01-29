/**
 * @file GeneralizedResultsContainerInterface.cxx
 * @brief Interface python de GeneralizedResultsContainer
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
#include "PythonBindings/GeneralizedResultsContainerInterface.h"


void exportGeneralizedResultsContainerToPython()
{


    py::class_< GeneralizedResultsContainerDoubleClass,
            GeneralizedResultsContainerDoublePtr,
            py::bases< DataStructure > >
            ( "GeneralizedResultsContainerDouble", py::no_init )
        // fake initFactoryPtr: created by subclasses
        // fake initFactoryPtr: created by subclasses
    ;

    py::class_< GeneralizedResultsContainerComplexClass,
            GeneralizedResultsContainerComplexPtr,
            py::bases< DataStructure > >
            ( "GeneralizedResultsContainerComplex", py::no_init )
        // fake initFactoryPtr: created by subclasses
        // fake initFactoryPtr: created by subclasses
    ;

    py::class_< TransientGeneralizedResultsContainerClass,
            TransientGeneralizedResultsContainerPtr,
            py::bases< GeneralizedResultsContainerDoubleClass > >
            ( "TransientGeneralizedResultsContainer", py::no_init )
        .def( "__init__", py::make_constructor(
            &initFactoryPtr< TransientGeneralizedResultsContainerClass >) )
        .def( "__init__", py::make_constructor(
            &initFactoryPtr< TransientGeneralizedResultsContainerClass,
                             std::string >) )
        .def( "setGeneralizedDOFNumbering",
              &TransientGeneralizedResultsContainerClass::setGeneralizedDOFNumbering )
        .def( "getGeneralizedDOFNumbering",
              &TransientGeneralizedResultsContainerClass::getGeneralizedDOFNumbering )
        .def( "setDOFNumbering",
              &TransientGeneralizedResultsContainerClass::setDOFNumbering )
        .def( "getDOFNumbering",
              &TransientGeneralizedResultsContainerClass::getDOFNumbering )
    ;

    py::class_< HarmoGeneralizedResultsContainerClass,
            HarmoGeneralizedResultsContainerPtr,
            py::bases< GeneralizedResultsContainerComplexClass > >
            ( "HarmoGeneralizedResultsContainer", py::no_init )
        .def( "__init__", py::make_constructor(
            &initFactoryPtr< HarmoGeneralizedResultsContainerClass >) )
        .def( "__init__", py::make_constructor(
            &initFactoryPtr< HarmoGeneralizedResultsContainerClass,
                             std::string >) )
        .def( "getGeneralizedDOFNumbering",
              &HarmoGeneralizedResultsContainerClass::getGeneralizedDOFNumbering )
        .def( "setGeneralizedDOFNumbering",
              &HarmoGeneralizedResultsContainerClass::setGeneralizedDOFNumbering )
        .def( "setDOFNumbering",
              &HarmoGeneralizedResultsContainerClass::setDOFNumbering )
        .def( "getDOFNumbering",
              &HarmoGeneralizedResultsContainerClass::getDOFNumbering )
    ;
};
