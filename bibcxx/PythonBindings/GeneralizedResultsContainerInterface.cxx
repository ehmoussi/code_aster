/**
 * @file GeneralizedResultsContainerInterface.cxx
 * @brief Interface python de GeneralizedResultsContainer
 * @author Natacha Béreux
 * @section LICENCE
 *   Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
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


    py::class_< GeneralizedResultsContainerDoubleInstance,
            GeneralizedResultsContainerDoublePtr,
            py::bases< DataStructure > >
            ( "GeneralizedResultsContainerDouble", py::no_init )
        // fake initFactoryPtr: created by subclasses
        // fake initFactoryPtr: created by subclasses
    ;

    py::class_< GeneralizedResultsContainerComplexInstance,
            GeneralizedResultsContainerComplexPtr,
            py::bases< DataStructure > >
            ( "GeneralizedResultsContainerComplex", py::no_init )
        // fake initFactoryPtr: created by subclasses
        // fake initFactoryPtr: created by subclasses
    ;

    py::class_< TransientGeneralizedResultsContainerInstance,
            TransientGeneralizedResultsContainerPtr,
            py::bases< GeneralizedResultsContainerDoubleInstance > >
            ( "TransientGeneralizedResultsContainer", py::no_init )
        .def( "__init__", py::make_constructor(
            &initFactoryPtr< TransientGeneralizedResultsContainerInstance >) )
        .def( "__init__", py::make_constructor(
            &initFactoryPtr< TransientGeneralizedResultsContainerInstance,
                             std::string >) )
        .def( "setGeneralizedDOFNumbering",
              &TransientGeneralizedResultsContainerInstance::setGeneralizedDOFNumbering )
        .def( "getGeneralizedDOFNumbering",
              &TransientGeneralizedResultsContainerInstance::getGeneralizedDOFNumbering )
        .def( "setDOFNumbering",
              &TransientGeneralizedResultsContainerInstance::setDOFNumbering )
        .def( "getDOFNumbering",
              &TransientGeneralizedResultsContainerInstance::getDOFNumbering )
    ;

    py::class_< HarmoGeneralizedResultsContainerInstance,
            HarmoGeneralizedResultsContainerPtr,
            py::bases< GeneralizedResultsContainerComplexInstance > >
            ( "HarmoGeneralizedResultsContainer", py::no_init )
        .def( "__init__", py::make_constructor(
            &initFactoryPtr< HarmoGeneralizedResultsContainerInstance >) )
        .def( "__init__", py::make_constructor(
            &initFactoryPtr< HarmoGeneralizedResultsContainerInstance,
                             std::string >) )
        .def( "getGeneralizedDOFNumbering",
              &HarmoGeneralizedResultsContainerInstance::getGeneralizedDOFNumbering )
        .def( "setGeneralizedDOFNumbering",
              &HarmoGeneralizedResultsContainerInstance::setGeneralizedDOFNumbering )
        .def( "setDOFNumbering",
              &HarmoGeneralizedResultsContainerInstance::setDOFNumbering )
        .def( "getDOFNumbering",
              &HarmoGeneralizedResultsContainerInstance::getDOFNumbering )
    ;
};
