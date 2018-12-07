/**
 * @file MeshInterface.cxx
 * @brief Interface python de Mesh
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2018  EDF R&D                www.code-aster.org
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
#include <Meshes/MeshEntities.h>
#include "PythonBindings/MeshInterface.h"
#include "PythonBindings/factory.h"
#include "PythonBindings/ConstViewerUtilities.h"

void exportMeshToPython() {
    using namespace boost::python;

    enum_< EntityType >( "EntityType" )
        .value( "GroupOfNodesType", GroupOfNodesType )
        .value( "GroupOfElementsType", GroupOfElementsType )
        .value( "AllMeshEntitiesType", AllMeshEntitiesType )
        .value( "ElementType", ElementType )
        .value( "NodeType", NodeType )
        .value( "NoType", NoType );

    class_< VirtualMeshEntity, MeshEntityPtr >( "MeshEntity", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< VirtualMeshEntity,
                                                            std::string, EntityType >))
        // fake initFactoryPtr: created by subclass
        .def( "getType", &VirtualMeshEntity::getType )
        .def( "getNames", &VirtualMeshEntity::getNames );

    class_< GroupOfElements, GroupOfElementsPtr,
            bases< VirtualMeshEntity > >( "GroupOfElements", no_init )
        // fake initFactoryPtr: created by subclass
        // fake initFactoryPtr: created by subclass
    ;

    class_< Element, ElementPtr,
            bases< VirtualMeshEntity > >( "Element", no_init )
        // fake initFactoryPtr: created by subclass
        // fake initFactoryPtr: created by subclass
    ;

    class_< AllMeshEntities, AllMeshEntitiesPtr,
            bases< VirtualMeshEntity > >( "AllMeshEntities", no_init )
        // fake initFactoryPtr: created by subclass
        // fake initFactoryPtr: created by subclass
    ;

    class_< BaseMeshInstance, BaseMeshInstance::BaseMeshPtr, bases< DataStructure > >( "BaseMesh",
                                                                                       no_init )
        // fake initFactoryPtr: created by subclass
        // fake initFactoryPtr: created by subclass
        //         .def( "getCoordinates", +[](const BaseMeshInstance& v)
        //         {
        //             return ConstViewer<MeshCoordinatesFieldInstance>( v.getCoordinates() );
        //         })
        .def( "getCoordinates", &BaseMeshInstance::getCoordinates )
        .def( "isParallel", &BaseMeshInstance::isParallel )
        .def( "getDimension", &BaseMeshInstance::getDimension )
    ;

    class_< MeshInstance, MeshInstance::MeshPtr, bases< BaseMeshInstance > >( "Mesh", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< MeshInstance >))
        .def( "__init__", make_constructor(&initFactoryPtr< MeshInstance, std::string >))
        .def( "addGroupOfNodesFromNodes", &MeshInstance::addGroupOfNodesFromNodes )
        .def( "hasGroupOfElements", &MeshInstance::hasGroupOfElements )
        .def( "hasGroupOfNodes", &MeshInstance::hasGroupOfNodes )
        .def( "readAsterMeshFile", &MeshInstance::readAsterMeshFile )
        .def( "readGibiFile", &MeshInstance::readGibiFile )
        .def( "readGmshFile", &MeshInstance::readGmshFile )
        .def( "readMedFile", &MeshInstance::readMedFile );
};
