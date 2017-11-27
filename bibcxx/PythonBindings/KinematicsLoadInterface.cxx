/**
 * @file KinematicsLoadInterface.cxx
 * @brief Interface python de KinematicsLoad
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

#include "PythonBindings/KinematicsLoadInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

void exportKinematicsLoadToPython()
{
    using namespace boost::python;

    bool (KinematicsLoadInstance::*c1)(const PhysicalQuantityComponent&,
                                       const double&,
                                       const std::string&) =
            &KinematicsLoadInstance::addImposedMechanicalDOFOnElements;
    bool (KinematicsLoadInstance::*c2)(const PhysicalQuantityComponent&,
                                       const double&,
                                       const std::vector< std::string >&) =
            &KinematicsLoadInstance::addImposedMechanicalDOFOnElements;

    bool (KinematicsLoadInstance::*c3)(const PhysicalQuantityComponent&,
                                       const double&,
                                       const std::string&) =
            &KinematicsLoadInstance::addImposedMechanicalDOFOnNodes;
    bool (KinematicsLoadInstance::*c4)(const PhysicalQuantityComponent&,
                                       const double&,
                                       const std::vector< std::string >&) =
            &KinematicsLoadInstance::addImposedMechanicalDOFOnNodes;

    bool (KinematicsLoadInstance::*c5)(const PhysicalQuantityComponent&,
                                       const double&,
                                       const std::string&) =
            &KinematicsLoadInstance::addImposedThermalDOFOnElements;
    bool (KinematicsLoadInstance::*c6)(const PhysicalQuantityComponent&,
                                       const double&,
                                       const std::vector< std::string >&) =
            &KinematicsLoadInstance::addImposedThermalDOFOnElements;

    bool (KinematicsLoadInstance::*c7)(const PhysicalQuantityComponent&,
                                       const double&,
                                       const std::string&) =
            &KinematicsLoadInstance::addImposedThermalDOFOnNodes;
    bool (KinematicsLoadInstance::*c8)(const PhysicalQuantityComponent&,
                                       const double&,
                                       const std::vector< std::string >&) =
            &KinematicsLoadInstance::addImposedThermalDOFOnNodes;

    class_< KinematicsLoadInstance, KinematicsLoadInstance::KinematicsLoadPtr,
            bases< DataStructure > > ( "KinematicsLoad", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< KinematicsLoadInstance > ) )
        .def( "addImposedMechanicalDOFOnElements", c1 )
        .def( "addImposedMechanicalDOFOnElements", c2 )
        .def( "addImposedMechanicalDOFOnNodes", c3 )
        .def( "addImposedMechanicalDOFOnNodes", c4 )
        .def( "addImposedThermalDOFOnElements", c5 )
        .def( "addImposedThermalDOFOnElements", c6 )
        .def( "addImposedThermalDOFOnNodes", c7 )
        .def( "addImposedThermalDOFOnNodes", c8 )
        .def( "build", &KinematicsLoadInstance::build )
        .def( "setSupportModel", &KinematicsLoadInstance::setSupportModel )
        .def( "setType", &KinematicsLoadInstance::setType )
    ;
};
