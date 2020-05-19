/**
 * @file BaseMeshInterface.cxx
 * @brief Interface python de BaseMesh
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

#include "PythonBindings/BaseMeshInterface.h"
#include "PythonBindings/factory.h"
#include <Meshes/BaseMesh.h>

namespace py = boost::python;

void exportBaseMeshToPython() {

    py::class_< BaseMeshClass, BaseMeshClass::BaseMeshPtr, py::bases< DataStructure > >(
        "BaseMesh", py::no_init )
        // fake initFactoryPtr: created by subclass
        // fake initFactoryPtr: created by subclass
        .def( "getNumberOfNodes", &BaseMeshClass::getNumberOfNodes, R"(
Return the number of nodes of the mesh.

Returns:
    int: Number of nodes.
        )",
              ( py::arg( "self" ) ) )
        .def( "getNumberOfCells", &BaseMeshClass::getNumberOfCells, R"(
Return the number of cells of the mesh.

Returns:
    int: Number of cells.
        )",
              ( py::arg( "self" ) ) )
        .def( "getCoordinates", &BaseMeshClass::getCoordinates, R"(
Return the coordinates of the mesh.

Returns:
    MeshCoordinatesField: Field of the coordinates.
        )",
              ( py::arg( "self" ) ) )
        .def( "isParallel", &BaseMeshClass::isParallel, R"(
Tell if the mesh is distributed on parallel instances.

Returns:
    bool: *False* for a centralized mesh, *True* for a parallel mesh.
        )",
              ( py::arg( "self" ) ) )
        .def( "getDimension", &BaseMeshClass::getDimension, R"(
Return the dimension of the mesh.

Returns:
    int: 2 or 3
        )",
              ( py::arg( "self" ) ) )
        .def( "getConnectivity", &BaseMeshClass::getConnectivity, R"(
Return the connectivity of the mesh as Python lists.

Returns:
    list[list[int]]: List of, for each cell, a list of the nodes indexes.
        )",
              ( py::arg( "self" ) ) );
};
