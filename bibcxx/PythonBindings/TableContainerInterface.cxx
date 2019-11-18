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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include <boost/python.hpp>
#include <PythonBindings/factory.h>
#include "PythonBindings/TableContainerInterface.h"
#include "PythonBindings/DataStructureInterface.h"

void exportTableContainerToPython() {
    using namespace boost::python;

    void ( TableContainerInstance::*c1 )( const std::string &,
                                          ElementaryMatrixDisplacementDoublePtr ) =
        &TableContainerInstance::addObject;
    void ( TableContainerInstance::*c2 )( const std::string &,
                                          ElementaryMatrixTemperatureDoublePtr ) =
        &TableContainerInstance::addObject;
    void ( TableContainerInstance::*c3 )( const std::string &,
                                          ElementaryVectorDisplacementDoublePtr ) =
        &TableContainerInstance::addObject;
    void ( TableContainerInstance::*c4 )( const std::string &,
                                          ElementaryVectorTemperatureDoublePtr ) =
        &TableContainerInstance::addObject;
    void ( TableContainerInstance::*c5 )( const std::string &,
                                          FieldOnElementsDoublePtr ) =
        &TableContainerInstance::addObject;
    void ( TableContainerInstance::*c6 )( const std::string &,
                                          FieldOnNodesDoublePtr ) =
        &TableContainerInstance::addObject;
    void ( TableContainerInstance::*c7 )( const std::string &,
                                          FunctionPtr ) =
        &TableContainerInstance::addObject;
    void ( TableContainerInstance::*c8 )( const std::string &,
                                          FunctionComplexPtr ) =
        &TableContainerInstance::addObject;
    void ( TableContainerInstance::*c9 )( const std::string &,
                                          GeneralizedAssemblyMatrixDoublePtr ) =
        &TableContainerInstance::addObject;
    void ( TableContainerInstance::*c10 )( const std::string &,
                                           GenericDataFieldPtr ) =
        &TableContainerInstance::addObject;
    void ( TableContainerInstance::*c11 )( const std::string &,
                                           MechanicalModeContainerPtr ) =
        &TableContainerInstance::addObject;
    void ( TableContainerInstance::*c12 )( const std::string &,
                                           PCFieldOnMeshDoublePtr ) =
        &TableContainerInstance::addObject;
    void ( TableContainerInstance::*c13 )( const std::string &,
                                           SurfacePtr ) =
        &TableContainerInstance::addObject;
    void ( TableContainerInstance::*c14 )( const std::string &,
                                           TablePtr ) =
        &TableContainerInstance::addObject;

    class_< TableContainerInstance, TableContainerInstance::TableContainerPtr,
            bases< TableInstance > >( "TableContainer", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< TableContainerInstance >) )
        .def( "__init__", make_constructor(&initFactoryPtr< TableContainerInstance, std::string >) )
        .def( "addObject", c1 )
        .def( "addObject", c2 )
        .def( "addObject", c3 )
        .def( "addObject", c4 )
        .def( "addObject", c5 )
        .def( "addObject", c6 )
        .def( "addObject", c7 )
        .def( "addObject", c8 )
        .def( "addObject", c9 )
        .def( "addObject", c10 )
        .def( "addObject", c11 )
        .def( "addObject", c12 )
        .def( "addObject", c13 )
        .def( "addObject", c14 )
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
