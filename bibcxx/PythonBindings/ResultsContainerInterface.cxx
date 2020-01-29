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

    MaterialOnMeshPtr ( ResultsContainerClass::*c1 )() =
        &ResultsContainerClass::getMaterialOnMesh;
    MaterialOnMeshPtr ( ResultsContainerClass::*c2 )( int ) =
        &ResultsContainerClass::getMaterialOnMesh;

    ModelPtr ( ResultsContainerClass::*c3 )() =
        &ResultsContainerClass::getModel;
    ModelPtr ( ResultsContainerClass::*c4 )( int ) =
        &ResultsContainerClass::getModel;

    ElementaryCharacteristicsPtr ( ResultsContainerClass::*c5 )() =
        &ResultsContainerClass::getElementaryCharacteristics;
    ElementaryCharacteristicsPtr ( ResultsContainerClass::*c6 )( int ) =
        &ResultsContainerClass::getElementaryCharacteristics;

    py::class_< ResultsContainerClass, ResultsContainerClass::ResultsContainerPtr,
            py::bases< DataStructure > >( "ResultsContainer", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ResultsContainerClass, std::string >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< ResultsContainerClass, std::string, std::string >))
        .def( "addFieldOnNodesDescription", &ResultsContainerClass::addFieldOnNodesDescription )
        .def( "addMaterialOnMesh", &ResultsContainerClass::addMaterialOnMesh )
        .def( "addModel", &ResultsContainerClass::addModel )
        .def( "appendElementaryCharacteristicsOnAllRanks",
              &ResultsContainerClass::appendElementaryCharacteristicsOnAllRanks )
        .def( "appendMaterialOnMeshOnAllRanks",
              &ResultsContainerClass::appendMaterialOnMeshOnAllRanks )
        .def( "appendModelOnAllRanks", &ResultsContainerClass::appendModelOnAllRanks )
        .def( "listFields", &ResultsContainerClass::listFields )
        .def( "getElementaryCharacteristics", c5 )
        .def( "getElementaryCharacteristics", c6 )
        .def( "getMaterialOnMesh", c1 )
        .def( "getMaterialOnMesh", c2 )
        .def( "getMesh", &ResultsContainerClass::getMesh )
        .def( "getModel", c3 )
        .def( "getModel", c4 )
        .def( "getNumberOfRanks", &ResultsContainerClass::getNumberOfRanks )
        .def( "getRanks", &ResultsContainerClass::getRanks )
        .def( "getRealFieldOnNodes", &ResultsContainerClass::getRealFieldOnNodes )
        .def( "getRealFieldOnElements", &ResultsContainerClass::getRealFieldOnElements )
        .def( "printMedFile", &ResultsContainerClass::printMedFile )
        .def( "setMesh", &ResultsContainerClass::setMesh )
        .def( "update", &ResultsContainerClass::update );
};
