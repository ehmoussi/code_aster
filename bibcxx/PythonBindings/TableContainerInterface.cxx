/**
 * @file TableContainerInterface.cxx
 * @brief Interface python de TableContainer
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include <boost/python.hpp>

namespace py = boost::python;
#include <PythonBindings/factory.h>
#include "PythonBindings/TableContainerInterface.h"
#include "PythonBindings/DataStructureInterface.h"

void exportTableContainerToPython() {

    void ( TableContainerClass::*c1 )( const std::string &,
                                          ElementaryMatrixDisplacementDoublePtr ) =
        &TableContainerClass::addObject;
    void ( TableContainerClass::*c2 )( const std::string &,
                                          ElementaryMatrixTemperatureDoublePtr ) =
        &TableContainerClass::addObject;
    void ( TableContainerClass::*c3 )( const std::string &,
                                          ElementaryVectorDisplacementDoublePtr ) =
        &TableContainerClass::addObject;
    void ( TableContainerClass::*c4 )( const std::string &,
                                          ElementaryVectorTemperatureDoublePtr ) =
        &TableContainerClass::addObject;
    void ( TableContainerClass::*c5 )( const std::string &, FieldOnCellsDoublePtr ) =
        &TableContainerClass::addObject;
    void ( TableContainerClass::*c6 )( const std::string &, FieldOnNodesDoublePtr ) =
        &TableContainerClass::addObject;
    void ( TableContainerClass::*c7 )( const std::string &, FunctionPtr ) =
        &TableContainerClass::addObject;
    void ( TableContainerClass::*c8 )( const std::string &, FunctionComplexPtr ) =
        &TableContainerClass::addObject;
    void ( TableContainerClass::*c9 )( const std::string &,
                                          GeneralizedAssemblyMatrixDoublePtr ) =
        &TableContainerClass::addObject;
    void ( TableContainerClass::*c10 )( const std::string &, GenericDataFieldPtr ) =
        &TableContainerClass::addObject;
    void ( TableContainerClass::*c11 )( const std::string &, MechanicalModeContainerPtr ) =
        &TableContainerClass::addObject;
    void ( TableContainerClass::*c12 )( const std::string &, PCFieldOnMeshDoublePtr ) =
        &TableContainerClass::addObject;
    void ( TableContainerClass::*c13 )( const std::string &, SurfacePtr ) =
        &TableContainerClass::addObject;
    void ( TableContainerClass::*c14 )( const std::string &, TablePtr ) =
        &TableContainerClass::addObject;

    py::class_< TableContainerClass, TableContainerClass::TableContainerPtr,
                py::bases< TableClass > >( "TableContainer", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< TableContainerClass >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< TableContainerClass, std::string >))
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
              &TableContainerClass::getElementaryMatrixDisplacementDouble )
        .def( "getElementaryMatrixTemperatureDouble",
              &TableContainerClass::getElementaryMatrixTemperatureDouble )
        .def( "getElementaryVectorDisplacementDouble",
              &TableContainerClass::getElementaryVectorDisplacementDouble )
        .def( "getElementaryVectorTemperatureDouble",
              &TableContainerClass::getElementaryVectorTemperatureDouble )
        .def( "getFieldOnCellsDouble", &TableContainerClass::getFieldOnCellsDouble )
        .def( "getFieldOnNodesDouble", &TableContainerClass::getFieldOnNodesDouble )
        .def( "getFunction", &TableContainerClass::getFunction )
        .def( "getFunctionComplex", &TableContainerClass::getFunctionComplex )
        .def( "getGeneralizedAssemblyMatrix",
              &TableContainerClass::getGeneralizedAssemblyMatrix )
        .def( "getGenericDataField", &TableContainerClass::getGenericDataField )
        .def( "getMechanicalModeContainer", &TableContainerClass::getMechanicalModeContainer )
        .def( "getPCFieldOnMeshDouble", &TableContainerClass::getPCFieldOnMeshDouble )
        .def( "getSurface", &TableContainerClass::getSurface )
        .def( "getTable", &TableContainerClass::getTable );
};
