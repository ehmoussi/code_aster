/**
 * @file TableContainerInterface.cxx
 * @brief Interface python de TableContainer
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include <boost/python.hpp>
#include <PythonBindings/factory.h>
#include "PythonBindings/TableContainerInterface.h"
#include "PythonBindings/DataStructureInterface.h"

void exportTableContainerToPython() {
    using namespace boost::python;

    class_< TableContainerInstance, TableContainerInstance::TableContainerPtr,
            bases< TableInstance > >( "TableContainer", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< TableContainerInstance >) )
        .def( "__init__", make_constructor(&initFactoryPtr< TableContainerInstance, std::string >) )
        .def( "getElementaryMatrixDisplacementDouble",
              &TableContainerInstance::getElementaryMatrixDisplacementDouble )
        .def( "getElementaryMatrixTemperatureDouble",
              &TableContainerInstance::getElementaryMatrixTemperatureDouble )
        .def( "getElementaryVectorDisplacementDouble",
              &TableContainerInstance::getElementaryVectorDisplacementDouble )
        .def( "getElementaryVectorTemperatureDouble",
              &TableContainerInstance::getElementaryVectorTemperatureDouble )
        .def( "getFieldOnElementsDouble", &TableContainerInstance::getFieldOnElementsDouble )
        .def( "getFieldOnNodesDouble", &TableContainerInstance::getFieldOnNodesDouble )
        .def( "getFunction", &TableContainerInstance::getFunction )
        .def( "getFunctionComplex", &TableContainerInstance::getFunctionComplex )
        .def( "getGeneralizedAssemblyMatrix",
              &TableContainerInstance::getGeneralizedAssemblyMatrix )
        .def( "getGenericDataField", &TableContainerInstance::getGenericDataField )
        .def( "getMechanicalModeContainer", &TableContainerInstance::getMechanicalModeContainer )
        .def( "getPCFieldOnMeshDouble", &TableContainerInstance::getPCFieldOnMeshDouble )
        .def( "getSurface", &TableContainerInstance::getSurface )
        .def( "getTable", &TableContainerInstance::getTable );
};
