/**
 * @file MaterialFieldInterface.cxx
 * @brief Interface python de MaterialField
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

#include "PythonBindings/MaterialFieldInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

namespace py = boost::python;

void exportMaterialFieldToPython()
{

    py::class_< PartOfMaterialFieldClass,
            PartOfMaterialFieldPtr > c2( "PartOfMaterialField", py::no_init );
    c2.def( "__init__", py::make_constructor(
            &initFactoryPtr< PartOfMaterialFieldClass > ) );
    c2.def( "__init__", py::make_constructor(
            &initFactoryPtr< PartOfMaterialFieldClass,
                             std::vector< MaterialPtr >, MeshEntityPtr > ) );
    c2.def( "getVectorOfMaterial", &PartOfMaterialFieldClass::getVectorOfMaterial );
    c2.def( "getMeshEntity", &PartOfMaterialFieldClass::getMeshEntity );

    py::class_< MaterialFieldClass, MaterialFieldClass::MaterialFieldPtr,
            py::bases< DataStructure > > c1( "MaterialField", py::no_init );
    c1.def( "__init__", py::make_constructor(
            &initFactoryPtr< MaterialFieldClass,
                             const MeshPtr& > ) );
    c1.def( "__init__", py::make_constructor(
            &initFactoryPtr< MaterialFieldClass,
                             const SkeletonPtr& > ) );
    c1.def( "__init__", py::make_constructor(
            &initFactoryPtr< MaterialFieldClass,
                             const std::string&,
                             const MeshPtr& > ) );
#ifdef _USE_MPI
    c1.def( "__init__", py::make_constructor(
            &initFactoryPtr< MaterialFieldClass,
                             const ParallelMeshPtr& > ) );
    c1.def( "__init__", py::make_constructor(
            &initFactoryPtr< MaterialFieldClass,
                             const std::string&,
                             const ParallelMeshPtr& > ) );
#endif /* _USE_MPI */
    c1.def( "addBehaviourOnAllMesh", &MaterialFieldClass::addBehaviourOnAllMesh );
    c1.def( "addBehaviourOnGroupOfCells",
              &MaterialFieldClass::addBehaviourOnGroupOfCells );
    c1.def( "addBehaviourOnElement",
              &MaterialFieldClass::addBehaviourOnElement );
    c1.def( "addMaterialsOnAllMesh", &MaterialFieldClass::addMaterialsOnAllMesh );
    c1.def( "addMaterialsOnGroupOfCells",
              &MaterialFieldClass::addMaterialsOnGroupOfCells );
    c1.def( "addMaterialsOnElement",
              &MaterialFieldClass::addMaterialsOnElement );
    c1.def( "addMaterialOnAllMesh", &MaterialFieldClass::addMaterialOnAllMesh );
    c1.def( "addMaterialOnGroupOfCells",
              &MaterialFieldClass::addMaterialOnGroupOfCells );
    c1.def( "addMaterialOnElement",
              &MaterialFieldClass::addMaterialOnElement );
    c1.def( "buildWithoutExternalVariable", &MaterialFieldClass::buildWithoutExternalVariable );
    c1.def( "getMesh", &MaterialFieldClass::getMesh );
    c1.def( "getVectorOfMaterial", &MaterialFieldClass::getVectorOfMaterial );
    c1.def( "getVectorOfPartOfMaterialField",
            &MaterialFieldClass::getVectorOfPartOfMaterialField );
    c1.def( "setModel", &MaterialFieldClass::setModel );
};
