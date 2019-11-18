/**
 * @file MaterialOnMeshInterface.cxx
 * @brief Interface python de MaterialOnMesh
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

#include "PythonBindings/MaterialOnMeshInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

void exportMaterialOnMeshToPython()
{
    using namespace boost::python;

    class_< PartOfMaterialOnMeshInstance,
            PartOfMaterialOnMeshPtr > c2( "PartOfMaterialOnMesh", no_init );
    c2.def( "__init__", make_constructor(
            &initFactoryPtr< PartOfMaterialOnMeshInstance > ) );
    c2.def( "__init__", make_constructor(
            &initFactoryPtr< PartOfMaterialOnMeshInstance,
                             std::vector< MaterialPtr >, MeshEntityPtr > ) );
    c2.def( "getVectorOfMaterial", &PartOfMaterialOnMeshInstance::getVectorOfMaterial );
    c2.def( "getMeshEntity", &PartOfMaterialOnMeshInstance::getMeshEntity );

    class_< MaterialOnMeshInstance, MaterialOnMeshInstance::MaterialOnMeshPtr,
            bases< DataStructure > > c1( "MaterialOnMesh", no_init );
    c1.def( "__init__", make_constructor(
            &initFactoryPtr< MaterialOnMeshInstance,
                             const MeshPtr& > ) );
    c1.def( "__init__", make_constructor(
            &initFactoryPtr< MaterialOnMeshInstance,
                             const SkeletonPtr& > ) );
    c1.def( "__init__", make_constructor(
            &initFactoryPtr< MaterialOnMeshInstance,
                             const std::string&,
                             const MeshPtr& > ) );
#ifdef _USE_MPI
    c1.def( "__init__", make_constructor(
            &initFactoryPtr< MaterialOnMeshInstance,
                             const ParallelMeshPtr& > ) );
    c1.def( "__init__", make_constructor(
            &initFactoryPtr< MaterialOnMeshInstance,
                             const std::string&,
                             const ParallelMeshPtr& > ) );
#endif /* _USE_MPI */
    c1.def( "addBehaviourOnAllMesh", &MaterialOnMeshInstance::addBehaviourOnAllMesh );
    c1.def( "addBehaviourOnGroupOfElements",
              &MaterialOnMeshInstance::addBehaviourOnGroupOfElements );
    c1.def( "addBehaviourOnElement",
              &MaterialOnMeshInstance::addBehaviourOnElement );
    c1.def( "addMaterialsOnAllMesh", &MaterialOnMeshInstance::addMaterialsOnAllMesh );
    c1.def( "addMaterialsOnGroupOfElements",
              &MaterialOnMeshInstance::addMaterialsOnGroupOfElements );
    c1.def( "addMaterialsOnElement",
              &MaterialOnMeshInstance::addMaterialsOnElement );
    c1.def( "addMaterialOnAllMesh", &MaterialOnMeshInstance::addMaterialOnAllMesh );
    c1.def( "addMaterialOnGroupOfElements",
              &MaterialOnMeshInstance::addMaterialOnGroupOfElements );
    c1.def( "addMaterialOnElement",
              &MaterialOnMeshInstance::addMaterialOnElement );
    c1.def( "buildWithoutInputVariables", &MaterialOnMeshInstance::buildWithoutInputVariables );
    c1.def( "getMesh", &MaterialOnMeshInstance::getMesh );
    c1.def( "getVectorOfMaterial", &MaterialOnMeshInstance::getVectorOfMaterial );
    c1.def( "getVectorOfPartOfMaterialOnMesh",
            &MaterialOnMeshInstance::getVectorOfPartOfMaterialOnMesh );
    c1.def( "setModel", &MaterialOnMeshInstance::setModel );
};
