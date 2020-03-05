/**
 * @file DrivingInterface.cxx
 * @brief Interface python de Driving
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

#include "PythonBindings/DrivingInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

namespace py = boost::python;

void exportDrivingToPython() {

    py::enum_< DrivingTypeEnum >( "DrivingType" )
        .value( "DisplacementValue", DisplacementValue )
        .value( "DisplacementNorm", DisplacementNorm )
        .value( "JumpOnCrackValue", JumpOnCrackValue )
        .value( "JumpOnCrackNorm", JumpOnCrackNorm )
        .value( "LimitLoad", LimitLoad )
        .value( "MonotonicStrain", MonotonicStrain )
        .value( "ElasticityLimit", ElasticityLimit );

    py::class_< DrivingClass, DrivingPtr >( "Driving", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< DrivingClass, DrivingTypeEnum >))
        // fake initFactoryPtr: not a DataStructure
        .def( "addObservationGroupOfNodes", &DrivingClass::addObservationGroupOfNodes )
        .def( "addObservationGroupOfCells", &DrivingClass::addObservationGroupOfCells )
        .def( "setDrivingDirectionOnCrack", &DrivingClass::setDrivingDirectionOnCrack )
        .def( "setMaximumValueOfDrivingParameter",
              &DrivingClass::setMaximumValueOfDrivingParameter )
        .def( "setMinimumValueOfDrivingParameter",
              &DrivingClass::setMinimumValueOfDrivingParameter )
        .def( "setLowerBoundOfDrivingParameter", &DrivingClass::setLowerBoundOfDrivingParameter )
        .def( "setUpperBoundOfDrivingParameter", &DrivingClass::setUpperBoundOfDrivingParameter )
        .def( "activateThreshold", &DrivingClass::activateThreshold )
        .def( "deactivateThreshold", &DrivingClass::deactivateThreshold )
        .def( "setMultiplicativeCoefficient", &DrivingClass::setMultiplicativeCoefficient );
};
