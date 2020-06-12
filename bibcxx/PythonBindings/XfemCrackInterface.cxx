/**
 * @file XfemCrackInterface.cxx
 * @brief Interface python de XfemCrack
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

#include "PythonBindings/XfemCrackInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

namespace py = boost::python;

void exportXfemCrackToPython() {

    py::class_< XfemCrackClass, XfemCrackClass::XfemCrackPtr, py::bases< DataStructure > >(
        "XfemCrack", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< XfemCrackClass, MeshPtr >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< XfemCrackClass, std::string, MeshPtr >))
        .def( "build", &XfemCrackClass::build )
        .def( "enrichModelWithXfem", &XfemCrackClass::enrichModelWithXfem )
        .def( "getMesh", &XfemCrackClass::getMesh )
        .def( "setMesh", &XfemCrackClass::setMesh )
        .def( "getAuxiliaryGrid", &XfemCrackClass::getAuxiliaryGrid )
        .def( "setAuxiliaryGrid", &XfemCrackClass::setAuxiliaryGrid )
        .def( "getExistingCrackWithGrid", &XfemCrackClass::getExistingCrackWithGrid )
        .def( "setExistingCrackWithGrid", &XfemCrackClass::setExistingCrackWithGrid )
        .def( "getDiscontinuityType", &XfemCrackClass::getDiscontinuityType )
        .def( "setDiscontinuityType", &XfemCrackClass::setDiscontinuityType )
        .def( "getCrackLipsEntity", &XfemCrackClass::getCrackLipsEntity )
        .def( "setCrackLipsEntity", &XfemCrackClass::setCrackLipsEntity )
        .def( "getCrackTipEntity", &XfemCrackClass::getCrackTipEntity )
        .def( "setCrackTipEntity", &XfemCrackClass::setCrackTipEntity )
        .def( "getCohesiveCrackTipForPropagation",
              &XfemCrackClass::getCohesiveCrackTipForPropagation )
        .def( "setCohesiveCrackTipForPropagation",
              &XfemCrackClass::setCohesiveCrackTipForPropagation )
        .def( "getNormalLevelSetFunction", &XfemCrackClass::getNormalLevelSetFunction )
        .def( "setNormalLevelSetFunction", &XfemCrackClass::setNormalLevelSetFunction )
        .def( "getTangentialLevelSetFunction", &XfemCrackClass::getTangentialLevelSetFunction )
        .def( "setTangentialLevelSetFunction", &XfemCrackClass::setTangentialLevelSetFunction )
        .def( "getCrackShape", &XfemCrackClass::getCrackShape )
        .def( "setCrackShape", &XfemCrackClass::setCrackShape )
        .def( "getNormalLevelSetField", &XfemCrackClass::getNormalLevelSetField )
        .def( "setNormalLevelSetField", &XfemCrackClass::setNormalLevelSetField )
        .def( "getTangentialLevelSetField", &XfemCrackClass::getTangentialLevelSetField )
        .def( "setTangentialLevelSetField", &XfemCrackClass::setTangentialLevelSetField )
        .def( "getEnrichedCells", &XfemCrackClass::getEnrichedCells )
        .def( "setEnrichedCells", &XfemCrackClass::setEnrichedCells )
        .def( "getDiscontinuousField", &XfemCrackClass::getDiscontinuousField )
        .def( "setDiscontinuousField", &XfemCrackClass::setDiscontinuousField )
        .def( "getEnrichmentType", &XfemCrackClass::getEnrichmentType )
        .def( "setEnrichmentType", &XfemCrackClass::setEnrichmentType )
        .def( "getEnrichmentRadiusZone", &XfemCrackClass::getEnrichmentRadiusZone )
        .def( "setEnrichmentRadiusZone", &XfemCrackClass::setEnrichmentRadiusZone )
        .def( "getEnrichedLayersNumber", &XfemCrackClass::getEnrichedLayersNumber )
        .def( "setEnrichedLayersNumber", &XfemCrackClass::setEnrichedLayersNumber )
        .def( "getJunctingCracks", &XfemCrackClass::getJunctingCracks )
        .def( "insertJunctingCracks", &XfemCrackClass::insertJunctingCracks )
        .def( "setPointForJunction", &XfemCrackClass::setPointForJunction );
};
