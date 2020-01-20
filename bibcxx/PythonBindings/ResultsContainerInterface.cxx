/**
 * @file ResultsContainerInterface.cxx
 * @brief Interface python de ResultsContainer
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

#include "PythonBindings/ResultsContainerInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

namespace py = boost::python;

void exportResultsContainerToPython() {

    MaterialOnMeshPtr ( ResultsContainerInstance::*c1 )() =
        &ResultsContainerInstance::getMaterialOnMesh;
    MaterialOnMeshPtr ( ResultsContainerInstance::*c2 )( int ) =
        &ResultsContainerInstance::getMaterialOnMesh;

    ModelPtr ( ResultsContainerInstance::*c3 )() =
        &ResultsContainerInstance::getModel;
    ModelPtr ( ResultsContainerInstance::*c4 )( int ) =
        &ResultsContainerInstance::getModel;

    ElementaryCharacteristicsPtr ( ResultsContainerInstance::*c5 )() =
        &ResultsContainerInstance::getElementaryCharacteristics;
    ElementaryCharacteristicsPtr ( ResultsContainerInstance::*c6 )( int ) =
        &ResultsContainerInstance::getElementaryCharacteristics;

    py::class_< ResultsContainerInstance, ResultsContainerInstance::ResultsContainerPtr,
            py::bases< DataStructure > >( "ResultsContainer", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ResultsContainerInstance, std::string >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< ResultsContainerInstance, std::string, std::string >))
        .def( "addFieldOnNodesDescription", &ResultsContainerInstance::addFieldOnNodesDescription )
        .def( "addMaterialOnMesh", &ResultsContainerInstance::addMaterialOnMesh )
        .def( "addModel", &ResultsContainerInstance::addModel )
        .def( "appendElementaryCharacteristicsOnAllRanks",
              &ResultsContainerInstance::appendElementaryCharacteristicsOnAllRanks )
        .def( "appendMaterialOnMeshOnAllRanks",
              &ResultsContainerInstance::appendMaterialOnMeshOnAllRanks )
        .def( "appendModelOnAllRanks", &ResultsContainerInstance::appendModelOnAllRanks )
        .def( "listFields", &ResultsContainerInstance::listFields )
        .def( "getElementaryCharacteristics", c5 )
        .def( "getElementaryCharacteristics", c6 )
        .def( "getMaterialOnMesh", c1 )
        .def( "getMaterialOnMesh", c2 )
        .def( "getMesh", &ResultsContainerInstance::getMesh )
        .def( "getModel", c3 )
        .def( "getModel", c4 )
        .def( "getNumberOfRanks", &ResultsContainerInstance::getNumberOfRanks )
        .def( "getRanks", &ResultsContainerInstance::getRanks )
        .def( "getRealFieldOnNodes", &ResultsContainerInstance::getRealFieldOnNodes )
        .def( "getRealFieldOnElements", &ResultsContainerInstance::getRealFieldOnElements )
        .def( "printMedFile", &ResultsContainerInstance::printMedFile )
        .def( "setMesh", &ResultsContainerInstance::setMesh )
        .def( "update", &ResultsContainerInstance::update );
};
