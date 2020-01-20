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
#include "PythonBindings/ConstViewerUtilities.h"
#include "PythonBindings/DataStructureInterface.h"
#include "PythonBindings/FieldOnNodesInterface.h"

void exportFieldOnNodesToPython() {

    py::class_< FieldOnNodesDoubleInstance, FieldOnNodesDoublePtr,
                py::bases< GenericDataFieldInstance > >( "FieldOnNodesDouble", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< FieldOnNodesDoubleInstance >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< FieldOnNodesDoubleInstance, std::string >))

        .def( "exportToSimpleFieldOnNodes",
              &FieldOnNodesDoubleInstance::exportToSimpleFieldOnNodes )
        .def( "getMesh", &FieldOnNodesDoubleInstance::getMesh )
        .def( "__getitem__",
              +[]( const FieldOnNodesDoubleInstance &v, int i ) { return v.operator[]( i ); } )
        .def( "printMedFile", &FieldOnNodesDoubleInstance::printMedFile )
        .def( "setDOFNumbering", &FieldOnNodesDoubleInstance::setDOFNumbering )
        .def( "setMesh", &FieldOnNodesDoubleInstance::setMesh )
        .def( "update", &FieldOnNodesDoubleInstance::update )
        .def( "updateValuePointers", &FieldOnNodesDoubleInstance::updateValuePointers );
    py::class_< FieldOnNodesComplexInstance, FieldOnNodesComplexPtr,
                py::bases< GenericDataFieldInstance > >( "FieldOnNodesComplex", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< FieldOnNodesComplexInstance >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< FieldOnNodesComplexInstance, std::string >))
        .def( "exportToSimpleFieldOnNodes",
              &FieldOnNodesComplexInstance::exportToSimpleFieldOnNodes )
        .def( "getMesh", &FieldOnNodesComplexInstance::getMesh )
        .def( "__getitem__",
              +[]( const FieldOnNodesComplexInstance &v, int i ) { return v.operator[]( i ); } )
        .def( "printMedFile", &FieldOnNodesComplexInstance::printMedFile )
        .def( "setDOFNumbering", &FieldOnNodesComplexInstance::setDOFNumbering )
        .def( "setMesh", &FieldOnNodesComplexInstance::setMesh )
        .def( "update", &FieldOnNodesComplexInstance::update )
        .def( "updateValuePointers", &FieldOnNodesComplexInstance::updateValuePointers );
};
