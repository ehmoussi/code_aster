/**
 * @file KinematicsLoadInterface.cxx
 * @brief Interface python de KinematicsLoad
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

#include "PythonBindings/KinematicsLoadInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

namespace py = boost::python;

void exportKinematicsLoadToPython() {

    bool ( KinematicsMechanicalLoadClass::*c1 )( const PhysicalQuantityComponent &,
                                                    const double &, const std::string & ) =
        &KinematicsMechanicalLoadClass::addImposedMechanicalDOFOnCells;
    bool ( KinematicsMechanicalLoadClass::*c2 )(
        const PhysicalQuantityComponent &, const double &, const VectorString & ) =
        &KinematicsMechanicalLoadClass::addImposedMechanicalDOFOnCells;

    bool ( KinematicsMechanicalLoadClass::*c3 )( const PhysicalQuantityComponent &,
                                                    const double &, const std::string & ) =
        &KinematicsMechanicalLoadClass::addImposedMechanicalDOFOnNodes;
    bool ( KinematicsMechanicalLoadClass::*c4 )(
        const PhysicalQuantityComponent &, const double &, const VectorString & ) =
        &KinematicsMechanicalLoadClass::addImposedMechanicalDOFOnNodes;

    bool ( KinematicsThermalLoadClass::*c5 )( const PhysicalQuantityComponent &, const double &,
                                                 const std::string & ) =
        &KinematicsThermalLoadClass::addImposedThermalDOFOnCells;
    bool ( KinematicsThermalLoadClass::*c6 )( const PhysicalQuantityComponent &, const double &,
                                                 const VectorString & ) =
        &KinematicsThermalLoadClass::addImposedThermalDOFOnCells;

    bool ( KinematicsThermalLoadClass::*c7 )( const PhysicalQuantityComponent &, const double &,
                                                 const std::string & ) =
        &KinematicsThermalLoadClass::addImposedThermalDOFOnNodes;
    bool ( KinematicsThermalLoadClass::*c8 )( const PhysicalQuantityComponent &, const double &,
                                                 const VectorString & ) =
        &KinematicsThermalLoadClass::addImposedThermalDOFOnNodes;
    bool ( KinematicsThermalLoadClass::*c9 )( const PhysicalQuantityComponent &,
                                                 const FunctionPtr &,
                                                 const VectorString & ) =
        &KinematicsThermalLoadClass::addImposedThermalDOFOnNodes;

    py::class_< KinematicsLoadClass, KinematicsLoadClass::KinematicsLoadPtr,
                py::bases< DataStructure > >( "KinematicsLoad", py::no_init )
        // fake initFactoryPtr: created by subclasses
        // fake initFactoryPtr: created by subclasses
        .def( "build", &KinematicsLoadClass::build )
        .def( "setModel", &KinematicsLoadClass::setModel );

    py::class_< KinematicsMechanicalLoadClass,
                KinematicsMechanicalLoadClass::KinematicsMechanicalLoadPtr,
                py::bases< KinematicsLoadClass > >( "KinematicsMechanicalLoad", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< KinematicsMechanicalLoadClass >))
        .def( "__init__", py::make_constructor(
                              &initFactoryPtr< KinematicsMechanicalLoadClass, std::string >))
        .def( "addImposedMechanicalDOFOnCells", c1 )
        .def( "addImposedMechanicalDOFOnCells", c2 )
        .def( "addImposedMechanicalDOFOnNodes", c3 )
        .def( "addImposedMechanicalDOFOnNodes", c4 );

    py::class_< KinematicsThermalLoadClass,
                KinematicsThermalLoadClass::KinematicsThermalLoadPtr,
                py::bases< KinematicsLoadClass > >( "KinematicsThermalLoad", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< KinematicsThermalLoadClass >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< KinematicsThermalLoadClass, std::string >))
        .def( "addImposedThermalDOFOnCells", c5 )
        .def( "addImposedThermalDOFOnCells", c6 )
        .def( "addImposedThermalDOFOnNodes", c7 )
        .def( "addImposedThermalDOFOnNodes", c8 )
        .def( "addImposedThermalDOFOnNodes", c9 );

    py::class_< KinematicsAcousticLoadClass,
                KinematicsAcousticLoadClass::KinematicsAcousticLoadPtr,
                py::bases< KinematicsLoadClass > >( "KinematicsAcousticLoad", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< KinematicsAcousticLoadClass >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< KinematicsAcousticLoadClass, std::string >));
};
