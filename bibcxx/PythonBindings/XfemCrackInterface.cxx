/**
 * @file XfemCrackInterface.cxx
 * @brief Interface python de XfemCrack
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
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

#include "PythonBindings/XfemCrackInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

void exportXfemCrackToPython() {
    using namespace boost::python;

    class_< XfemCrackInstance, XfemCrackInstance::XfemCrackPtr, bases< DataStructure > >(
        "XfemCrack", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< XfemCrackInstance, MeshPtr >))
        .def( "__init__",
              make_constructor(&initFactoryPtr< XfemCrackInstance, std::string, MeshPtr >))
        .def( "build", &XfemCrackInstance::build )
        .def( "enrichModelWithXfem", &XfemCrackInstance::enrichModelWithXfem )
        .def( "getMesh", &XfemCrackInstance::getMesh )
        .def( "setMesh", &XfemCrackInstance::setMesh )
        .def( "getAuxiliaryGrid", &XfemCrackInstance::getAuxiliaryGrid )
        .def( "setAuxiliaryGrid", &XfemCrackInstance::setAuxiliaryGrid )
        .def( "getExistingCrackWithGrid", &XfemCrackInstance::getExistingCrackWithGrid )
        .def( "setExistingCrackWithGrid", &XfemCrackInstance::setExistingCrackWithGrid )
        .def( "getDiscontinuityType", &XfemCrackInstance::getDiscontinuityType )
        .def( "setDiscontinuityType", &XfemCrackInstance::setDiscontinuityType )
        .def( "getCrackLipsEntity", &XfemCrackInstance::getCrackLipsEntity )
        .def( "setCrackLipsEntity", &XfemCrackInstance::setCrackLipsEntity )
        .def( "getCrackTipEntity", &XfemCrackInstance::getCrackTipEntity )
        .def( "setCrackTipEntity", &XfemCrackInstance::setCrackTipEntity )
        .def( "getCohesiveCrackTipForPropagation",
              &XfemCrackInstance::getCohesiveCrackTipForPropagation )
        .def( "setCohesiveCrackTipForPropagation",
              &XfemCrackInstance::setCohesiveCrackTipForPropagation )
        .def( "getNormalLevelSetFunction", &XfemCrackInstance::getNormalLevelSetFunction )
        .def( "setNormalLevelSetFunction", &XfemCrackInstance::setNormalLevelSetFunction )
        .def( "getTangentialLevelSetFunction", &XfemCrackInstance::getTangentialLevelSetFunction )
        .def( "setTangentialLevelSetFunction", &XfemCrackInstance::setTangentialLevelSetFunction )
        .def( "getCrackShape", &XfemCrackInstance::getCrackShape )
        .def( "setCrackShape", &XfemCrackInstance::setCrackShape )
        .def( "getNormalLevelSetField", &XfemCrackInstance::getNormalLevelSetField )
        .def( "setNormalLevelSetField", &XfemCrackInstance::setNormalLevelSetField )
        .def( "getTangentialLevelSetField", &XfemCrackInstance::getTangentialLevelSetField )
        .def( "setTangentialLevelSetField", &XfemCrackInstance::setTangentialLevelSetField )
        .def( "getEnrichedElements", &XfemCrackInstance::getEnrichedElements )
        .def( "setEnrichedElements", &XfemCrackInstance::setEnrichedElements )
        .def( "getDiscontinuousField", &XfemCrackInstance::getDiscontinuousField )
        .def( "setDiscontinuousField", &XfemCrackInstance::setDiscontinuousField )
        .def( "getEnrichmentType", &XfemCrackInstance::getEnrichmentType )
        .def( "setEnrichmentType", &XfemCrackInstance::setEnrichmentType )
        .def( "getEnrichmentRadiusZone", &XfemCrackInstance::getEnrichmentRadiusZone )
        .def( "setEnrichmentRadiusZone", &XfemCrackInstance::setEnrichmentRadiusZone )
        .def( "getEnrichedLayersNumber", &XfemCrackInstance::getEnrichedLayersNumber )
        .def( "setEnrichedLayersNumber", &XfemCrackInstance::setEnrichedLayersNumber )
        .def( "getJunctingCracks", &XfemCrackInstance::getJunctingCracks )
        .def( "insertJunctingCracks", &XfemCrackInstance::insertJunctingCracks )
        .def( "setPointForJunction", &XfemCrackInstance::setPointForJunction );
};
