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
#include <PythonBindings/factory.h>
#include "PythonBindings/GeneralizedResultsContainerInterface.h"


void exportGeneralizedResultsContainerToPython()
{
    using namespace boost::python;


    class_< GeneralizedResultsContainerDoubleInstance,
            GeneralizedResultsContainerDoublePtr,
            bases< DataStructure > >
            ( "GeneralizedResultsContainerDouble", no_init )
        // fake initFactoryPtr: created by subclasses
        // fake initFactoryPtr: created by subclasses
    ;

    class_< GeneralizedResultsContainerComplexInstance,
            GeneralizedResultsContainerComplexPtr,
            bases< DataStructure > >
            ( "GeneralizedResultsContainerComplex", no_init )
        // fake initFactoryPtr: created by subclasses
        // fake initFactoryPtr: created by subclasses
    ;

    class_< TransientGeneralizedResultsContainerInstance,
            TransientGeneralizedResultsContainerPtr,
            bases< GeneralizedResultsContainerDoubleInstance > >
            ( "TransientGeneralizedResultsContainer", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< TransientGeneralizedResultsContainerInstance >) )
        .def( "__init__", make_constructor(
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

    class_< HarmoGeneralizedResultsContainerInstance,
            HarmoGeneralizedResultsContainerPtr,
            bases< GeneralizedResultsContainerComplexInstance > >
            ( "HarmoGeneralizedResultsContainer", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< HarmoGeneralizedResultsContainerInstance >) )
        .def( "__init__", make_constructor(
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
