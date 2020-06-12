/**
 * @file exportMeshCoordinatesFieldToPython.cxx
 * @brief Interface python de MeshCoordinates
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

#include "PythonBindings/MeshCoordinatesFieldInterface.h"
#include "DataFields/MeshCoordinatesField.h"
#include "PythonBindings/DataStructureInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

namespace py = boost::python;

void exportMeshCoordinatesFieldToPython() {

    py::class_< MeshCoordinatesFieldClass, MeshCoordinatesFieldPtr, py::bases< DataStructure > >(
        "MeshCoordinatesField", py::no_init )
        // fake initFactoryPtr: no default constructor, only for restart
        .def( "__init__",
              py::make_constructor( &initFactoryPtr< MeshCoordinatesFieldClass, std::string > ) )
        .def( "__getitem__",
              +[]( const MeshCoordinatesFieldClass &v, int i ) { return v.operator[]( i ); }, R"(
Return the coordinate at index *idx* in the vector.

The value is the same as *getValues()[idx]* without creating the entire vector.

Returns:
    float: Values of the *idx*-th coordinate.
        )",
            ( py::arg( "self" ), py::arg( "idx" ) ) )
        .def( "getValues", &MeshCoordinatesFieldClass::getValues, R"(
Return a list of values of the coordinates as (x1, y1, z1, x2, y2, z2...)

Returns:
    list[float]: List of coordinates (size = 3 * number of nodes).
        )",
            ( py::arg( "self" ) ) );
};
