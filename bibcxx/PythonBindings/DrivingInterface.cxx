/**
 * @file DrivingInterface.cxx
 * @brief Interface python de Driving
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

#include "PythonBindings/DrivingInterface.h"
#include "PythonBindings/SharedPtrUtilities.h"
#include <boost/python.hpp>

void exportDrivingToPython()
{
    using namespace boost::python;

    enum_< DrivingTypeEnum >( "DrivingTypeEnum" )
        .value( "DisplacementValue", DisplacementValue )
        .value( "DisplacementNorm", DisplacementNorm )
        .value( "JumpOnCrackValue", JumpOnCrackValue )
        .value( "JumpOnCrackNorm", JumpOnCrackNorm )
        .value( "LimitLoad", LimitLoad )
        .value( "MonotonicStrain", MonotonicStrain )
        .value( "ElasticityLimit", ElasticityLimit )
        ;

    class_< DrivingInstance, DrivingPtr > ( "Driving", no_init )
        .def( "create", &createSharedPtr< DrivingInstance, DrivingTypeEnum > )
        .staticmethod( "create" )
        .def( "addObservationGroupOfNodes", &DrivingInstance::addObservationGroupOfNodes )
        .def( "addObservationGroupOfElements",
              &DrivingInstance::addObservationGroupOfElements )
        .def( "setDrivingDirectionOnCrack", &DrivingInstance::setDrivingDirectionOnCrack )
        .def( "setMaximumValueOfDrivingParameter",
              &DrivingInstance::setMaximumValueOfDrivingParameter )
        .def( "setMinimumValueOfDrivingParameter",
              &DrivingInstance::setMinimumValueOfDrivingParameter )
        .def( "setLowerBoundOfDrivingParameter",
              &DrivingInstance::setLowerBoundOfDrivingParameter )
        .def( "setUpperBoundOfDrivingParameter",
              &DrivingInstance::setUpperBoundOfDrivingParameter )
        .def( "activateThreshold", &DrivingInstance::activateThreshold )
        .def( "deactivateThreshold", &DrivingInstance::deactivateThreshold )
        .def( "setMultiplicativeCoefficient",
              &DrivingInstance::setMultiplicativeCoefficient )
    ;
};
