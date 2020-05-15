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

namespace py = boost::python;
#include "PythonBindings/ConstViewerUtilities.h"
#include "PythonBindings/MeshInterface.h"
#include "PythonBindings/factory.h"
#include <Meshes/MeshEntities.h>
#include <PythonBindings/factory.h>

void exportMeshToPython() {

    py::enum_< EntityType >( "EntityType" )
        .value( "GroupOfNodesType", GroupOfNodesType )
        .value( "GroupOfCellsType", GroupOfCellsType )
        .value( "AllMeshEntitiesType", AllMeshEntitiesType )
        .value( "CellType", CellType )
        .value( "NodeType", NodeType )
        .value( "NoType", NoType );

    py::class_< VirtualMeshEntity, MeshEntityPtr >( "MeshEntity", py::no_init )
        .def( "__init__", py::make_constructor(
                              &initFactoryPtr< VirtualMeshEntity, std::string, EntityType > ) )
        // fake initFactoryPtr: created by subclass
        .def( "getType", &VirtualMeshEntity::getType )
        .def( "getNames", &VirtualMeshEntity::getNames );

    py::class_< AllMeshEntities, AllMeshEntitiesPtr, py::bases< VirtualMeshEntity > >(
        "AllMeshEntities", py::no_init )
        // fake initFactoryPtr: created by subclass
        // fake initFactoryPtr: created by subclass
        ;

    py::class_< BaseMeshClass, BaseMeshClass::BaseMeshPtr, py::bases< DataStructure > >(
        "BaseMesh", py::no_init )
        // fake initFactoryPtr: created by subclass
        // fake initFactoryPtr: created by subclass
        //         .def( "getCoordinates", +[](const BaseMeshClass& v)
        //         {
        //             return ConstViewer<MeshCoordinatesFieldClass>( v.getCoordinates() );
        //         })
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

    py::class_< MeshClass, MeshClass::MeshPtr, py::bases< BaseMeshClass > >( "Mesh", py::no_init )
        .def( "__init__", py::make_constructor( &initFactoryPtr< MeshClass > ) )
        .def( "__init__", py::make_constructor( &initFactoryPtr< MeshClass, std::string > ) )
        .def( "getGroupsOfCells", &MeshClass::getGroupsOfCells, R"(
Return the list of the existing groups of cells.

Returns:
    list[str]: List of groups names (stripped).
        )",
              ( py::arg( "self" ) ) )
        .def( "getGroupsOfNodes", &MeshClass::getGroupsOfNodes, R"(
Return the list of the existing groups of nodes.

Returns:
    list[str]: List of groups names (stripped).
        )",
              ( py::arg( "self" ) ) )
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
