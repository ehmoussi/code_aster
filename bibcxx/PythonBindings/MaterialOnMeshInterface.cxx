/**
 * @file MaterialOnMeshInterface.cxx
 * @brief Interface python de MaterialOnMesh
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

#include "PythonBindings/MaterialOnMeshInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

namespace py = boost::python;

void exportMaterialOnMeshToPython()
{

    py::class_< PartOfMaterialOnMeshClass,
            PartOfMaterialOnMeshPtr > c2( "PartOfMaterialOnMesh", py::no_init );
    c2.def( "__init__", py::make_constructor(
            &initFactoryPtr< PartOfMaterialOnMeshClass > ) );
    c2.def( "__init__", py::make_constructor(
            &initFactoryPtr< PartOfMaterialOnMeshClass,
                             std::vector< MaterialPtr >, MeshEntityPtr > ) );
    c2.def( "getVectorOfMaterial", &PartOfMaterialOnMeshClass::getVectorOfMaterial );
    c2.def( "getMeshEntity", &PartOfMaterialOnMeshClass::getMeshEntity );

    py::class_< MaterialOnMeshClass, MaterialOnMeshClass::MaterialOnMeshPtr,
            py::bases< DataStructure > > c1( "MaterialOnMesh", py::no_init );
    c1.def( "__init__", py::make_constructor(
            &initFactoryPtr< MaterialOnMeshClass,
                             const MeshPtr& > ) );
    c1.def( "__init__", py::make_constructor(
            &initFactoryPtr< MaterialOnMeshClass,
                             const SkeletonPtr& > ) );
    c1.def( "__init__", py::make_constructor(
            &initFactoryPtr< MaterialOnMeshClass,
                             const std::string&,
                             const MeshPtr& > ) );
#ifdef _USE_MPI
    c1.def( "__init__", py::make_constructor(
            &initFactoryPtr< MaterialOnMeshClass,
                             const ParallelMeshPtr& > ) );
    c1.def( "__init__", py::make_constructor(
            &initFactoryPtr< MaterialOnMeshClass,
                             const std::string&,
                             const ParallelMeshPtr& > ) );
#endif /* _USE_MPI */
    c1.def( "addBehaviourOnAllMesh", &MaterialOnMeshClass::addBehaviourOnAllMesh );
    c1.def( "addBehaviourOnGroupOfElements",
              &MaterialOnMeshClass::addBehaviourOnGroupOfElements );
    c1.def( "addBehaviourOnElement",
              &MaterialOnMeshClass::addBehaviourOnElement );
    c1.def( "addMaterialsOnAllMesh", &MaterialOnMeshClass::addMaterialsOnAllMesh );
    c1.def( "addMaterialsOnGroupOfElements",
              &MaterialOnMeshClass::addMaterialsOnGroupOfElements );
    c1.def( "addMaterialsOnElement",
              &MaterialOnMeshClass::addMaterialsOnElement );
    c1.def( "addMaterialOnAllMesh", &MaterialOnMeshClass::addMaterialOnAllMesh );
    c1.def( "addMaterialOnGroupOfElements",
              &MaterialOnMeshClass::addMaterialOnGroupOfElements );
    c1.def( "addMaterialOnElement",
              &MaterialOnMeshClass::addMaterialOnElement );
    c1.def( "buildWithoutInputVariables", &MaterialOnMeshClass::buildWithoutInputVariables );
    c1.def( "getMesh", &MaterialOnMeshClass::getMesh );
    c1.def( "getVectorOfMaterial", &MaterialOnMeshClass::getVectorOfMaterial );
    c1.def( "getVectorOfPartOfMaterialOnMesh",
            &MaterialOnMeshClass::getVectorOfPartOfMaterialOnMesh );
    c1.def( "setModel", &MaterialOnMeshClass::setModel );
};
