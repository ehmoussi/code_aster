/**
 * @file FieldOnNodesInterface.cxx
 * @brief Interface python de FieldOnNodes
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

#include "DataFields/MeshCoordinatesField.h"
#include "PythonBindings/DataStructureInterface.h"
#include "PythonBindings/FieldOnNodesInterface.h"

void exportFieldOnNodesToPython() {

    py::class_< FieldOnNodesRealClass, FieldOnNodesRealPtr,
                py::bases< DataFieldClass > >( "FieldOnNodesReal", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< FieldOnNodesRealClass >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< FieldOnNodesRealClass, std::string >))

        .def( "exportToSimpleFieldOnNodes",
              &FieldOnNodesRealClass::exportToSimpleFieldOnNodes )
        .def( "getMesh", &FieldOnNodesRealClass::getMesh )
        .def( "__getitem__",
              +[]( const FieldOnNodesRealClass &v, int i ) { return v.operator[]( i ); } )
        .def( "printMedFile", &FieldOnNodesRealClass::printMedFile )
        .def( "setDOFNumbering", &FieldOnNodesRealClass::setDOFNumbering )
        .def( "setMesh", &FieldOnNodesRealClass::setMesh )
        .def( "update", &FieldOnNodesRealClass::update )
        .def( "updateValuePointers", &FieldOnNodesRealClass::updateValuePointers );
    py::class_< FieldOnNodesComplexClass, FieldOnNodesComplexPtr,
                py::bases< DataFieldClass > >( "FieldOnNodesComplex", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< FieldOnNodesComplexClass >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< FieldOnNodesComplexClass, std::string >))
        .def( "exportToSimpleFieldOnNodes",
              &FieldOnNodesComplexClass::exportToSimpleFieldOnNodes )
        .def( "getMesh", &FieldOnNodesComplexClass::getMesh )
        .def( "__getitem__",
              +[]( const FieldOnNodesComplexClass &v, int i ) { return v.operator[]( i ); } )
        .def( "printMedFile", &FieldOnNodesComplexClass::printMedFile )
        .def( "setDOFNumbering", &FieldOnNodesComplexClass::setDOFNumbering )
        .def( "setMesh", &FieldOnNodesComplexClass::setMesh )
        .def( "update", &FieldOnNodesComplexClass::update )
        .def( "updateValuePointers", &FieldOnNodesComplexClass::updateValuePointers );
};
