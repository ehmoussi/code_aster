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
#include <PythonBindings/factory.h>
#include <Meshes/MeshEntities.h>
#include "PythonBindings/MeshInterface.h"
#include "PythonBindings/factory.h"
#include "PythonBindings/ConstViewerUtilities.h"

void exportMeshToPython() {

    py::enum_< EntityType >( "EntityType" )
        .value( "GroupOfNodesType", GroupOfNodesType )
        .value( "GroupOfCellsType", GroupOfCellsType )
        .value( "AllMeshEntitiesType", AllMeshEntitiesType )
        .value( "ElementType", ElementType )
        .value( "NodeType", NodeType )
        .value( "NoType", NoType );

    py::class_< VirtualMeshEntity, MeshEntityPtr >( "MeshEntity", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< VirtualMeshEntity, std::string, EntityType >))
        // fake initFactoryPtr: created by subclass
        .def( "getType", &VirtualMeshEntity::getType )
        .def( "getNames", &VirtualMeshEntity::getNames );

    py::class_< GroupOfCells, GroupOfCellsPtr, py::bases< VirtualMeshEntity > >(
        "GroupOfCells", py::no_init )
        // fake initFactoryPtr: created by subclass
        // fake initFactoryPtr: created by subclass
        ;

    py::class_< Element, ElementPtr, py::bases< VirtualMeshEntity > >( "Element", py::no_init )
        // fake initFactoryPtr: created by subclass
        // fake initFactoryPtr: created by subclass
        ;

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
        .def( "getCoordinates", &BaseMeshClass::getCoordinates )
        .def( "isParallel", &BaseMeshClass::isParallel )
        .def( "getDimension", &BaseMeshClass::getDimension );

    py::class_< MeshClass, MeshClass::MeshPtr, py::bases< BaseMeshClass > >( "Mesh",
                                                                                      py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< MeshClass >))
        .def( "__init__", py::make_constructor(&initFactoryPtr< MeshClass, std::string >))
        .def( "addGroupOfNodesFromNodes", &MeshClass::addGroupOfNodesFromNodes )
        .def( "hasGroupOfCells", &MeshClass::hasGroupOfCells )
        .def( "hasGroupOfNodes", &MeshClass::hasGroupOfNodes )
        .def( "readAsterMeshFile", &MeshClass::readAsterMeshFile )
        .def( "readGibiFile", &MeshClass::readGibiFile )
        .def( "readGmshFile", &MeshClass::readGmshFile )
        .def( "readMedFile", &MeshClass::readMedFile );
};
