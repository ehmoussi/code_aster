/**
 * @file MeshInterface.cxx
 * @brief Interface python de Mesh
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

#include "PythonBindings/MeshInterface.h"
#include <Meshes/BaseMesh.h>
#include <Meshes/Mesh.h>
#include <Meshes/MeshEntities.h>
#include <PythonBindings/factory.h>

namespace py = boost::python;

void exportMeshToPython() {

    py::class_< MeshClass, MeshClass::MeshPtr, py::bases< BaseMeshClass > >( "Mesh", py::no_init )
        .def( "__init__", py::make_constructor( &initFactoryPtr< MeshClass > ) )
        .def( "__init__", py::make_constructor( &initFactoryPtr< MeshClass, std::string > ) )
        .def( "getGroupsOfCells", &MeshClass::getGroupsOfCells, R"(
Return the list of the existing groups of cells.

Returns:
    list[str]: List of groups names (stripped).
        )",
              ( py::arg( "self" ) ) )
        .def( "getCells", &MeshClass::getCells, R"(
Return the list of the indexes of the cells that belong to a group of cells.

Arguments:
    group_name (str): Name of the group.

Returns:
    list[int]: Indexes of the cells of the group.
        )",
              ( py::arg( "self" ), py::arg( "group_name" ) ) )
        .def( "getGroupsOfNodes", &MeshClass::getGroupsOfNodes, R"(
Return the list of the existing groups of nodes.

Returns:
    list[str]: List of groups names (stripped).
        )",
              ( py::arg( "self" ) ) )
        .def( "getNodes", &MeshClass::getNodes, R"(
Return the list of the indexes of the nodes that belong to a group of nodes.

Arguments:
    group_name (str): Name of the group.

Returns:
    list[int]: Indexes of the nodes of the group.
        )",
              ( py::arg( "self" ), py::arg( "group_name" ) ) )
        .def( "readAsterFile", &MeshClass::readAsterFile, R"(
Read a mesh file from ASTER format.

Arguments:
    filename (str): Path to the file to be read.

Returns:
    bool: *True* if succeeds, *False* otherwise.
        )",
              ( py::arg( "self" ), py::arg( "filename" ) ) )
        .def( "readGibiFile", &MeshClass::readGibiFile, R"(
Read a mesh file from GIBI format.

Arguments:
    filename (str): Path to the file to be read.

Returns:
    bool: *True* if succeeds, *False* otherwise.
        )",
              ( py::arg( "self" ), py::arg( "filename" ) ) )
        .def( "readGmshFile", &MeshClass::readGmshFile, R"(
Read a mesh file from GMSH format.

Arguments:
    filename (str): Path to the file to be read.

Returns:
    bool: *True* if succeeds, *False* otherwise.
        )",
              ( py::arg( "self" ), py::arg( "filename" ) ) )
        .def( "readMedFile", &MeshClass::readMedFile, R"(
Read a mesh file from MED format.

Arguments:
    filename (str): Path to the file to be read.

Returns:
    bool: *True* if succeeds, *False* otherwise.
        )",
              ( py::arg( "self" ), py::arg( "filename" ) ) );
};
