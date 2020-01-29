/**
 * @file CrackShapeInterface.cxx
 * @brief Interface python de CrackShape
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

#include "PythonBindings/CrackShapeInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

namespace py = boost::python;

void exportCrackShapeToPython() {

    py::class_< CrackShapeClass, CrackShapeClass::CrackShapePtr >( "CrackShape", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< CrackShapeClass >))
        // fake initFactoryPtr: not a DataStructure
        .def( "setEllipseCrackShape", &CrackShapeClass::setEllipseCrackShape )
        .def( "setSquareCrackShape", &CrackShapeClass::setSquareCrackShape )
        .def( "setCylinderCrackShape", &CrackShapeClass::setCylinderCrackShape )
        .def( "setNotchCrackShape", &CrackShapeClass::setNotchCrackShape )
        .def( "setHalfPlaneCrackShape", &CrackShapeClass::setHalfPlaneCrackShape )
        .def( "setSegmentCrackShape", &CrackShapeClass::setSegmentCrackShape )
        .def( "setHalfLineCrackShape", &CrackShapeClass::setHalfLineCrackShape )
        .def( "setLineCrackShape", &CrackShapeClass::setLineCrackShape )
        .def( "getShape", &CrackShapeClass::getShape )
        .def( "getShapeName", &CrackShapeClass::getShapeName )
        .def( "getSemiMajorAxis", &CrackShapeClass::getSemiMajorAxis )
        .def( "getSemiMinorAxis", &CrackShapeClass::getSemiMinorAxis )
        .def( "getCenter", &CrackShapeClass::getCenter )
        .def( "getVectX", &CrackShapeClass::getVectX )
        .def( "getVectY", &CrackShapeClass::getVectY )
        .def( "getCrackSide", &CrackShapeClass::getCrackSide )
        .def( "getFilletRadius", &CrackShapeClass::getFilletRadius )
        .def( "getHalfLength", &CrackShapeClass::getHalfLength )
        .def( "getEndPoint", &CrackShapeClass::getEndPoint )
        .def( "getNormal", &CrackShapeClass::getNormal )
        .def( "getTangent", &CrackShapeClass::getTangent )
        .def( "getStartingPoint", &CrackShapeClass::getStartingPoint );
};
