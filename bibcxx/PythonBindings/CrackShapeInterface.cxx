/**
 * @file CrackShapeInterface.cxx
 * @brief Interface python de CrackShape
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2018  EDF R&D                www.code-aster.org
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

// Not a DataStructure
// aslint: disable=C3006

#include "PythonBindings/CrackShapeInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

void exportCrackShapeToPython() {
    using namespace boost::python;

    class_< CrackShapeInstance, CrackShapeInstance::CrackShapePtr >( "CrackShape", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< CrackShapeInstance >))
        .def( "setEllipseCrackShape", &CrackShapeInstance::setEllipseCrackShape )
        .def( "setSquareCrackShape", &CrackShapeInstance::setSquareCrackShape )
        .def( "setCylinderCrackShape", &CrackShapeInstance::setCylinderCrackShape )
        .def( "setNotchCrackShape", &CrackShapeInstance::setNotchCrackShape )
        .def( "setHalfPlaneCrackShape", &CrackShapeInstance::setHalfPlaneCrackShape )
        .def( "setSegmentCrackShape", &CrackShapeInstance::setSegmentCrackShape )
        .def( "setHalfLineCrackShape", &CrackShapeInstance::setHalfLineCrackShape )
        .def( "setLineCrackShape", &CrackShapeInstance::setLineCrackShape )
        .def( "getShape", &CrackShapeInstance::getShape )
        .def( "getShapeName", &CrackShapeInstance::getShapeName )
        .def( "getSemiMajorAxis", &CrackShapeInstance::getSemiMajorAxis )
        .def( "getSemiMinorAxis", &CrackShapeInstance::getSemiMinorAxis )
        .def( "getCenter", &CrackShapeInstance::getCenter )
        .def( "getVectX", &CrackShapeInstance::getVectX )
        .def( "getVectY", &CrackShapeInstance::getVectY )
        .def( "getCrackSide", &CrackShapeInstance::getCrackSide )
        .def( "getFilletRadius", &CrackShapeInstance::getFilletRadius )
        .def( "getHalfLength", &CrackShapeInstance::getHalfLength )
        .def( "getEndPoint", &CrackShapeInstance::getEndPoint )
        .def( "getNormal", &CrackShapeInstance::getNormal )
        .def( "getTangent", &CrackShapeInstance::getTangent )
        .def( "getStartingPoint", &CrackShapeInstance::getStartingPoint );
};
