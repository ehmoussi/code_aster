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

void exportMaterialFieldToPython() {

    py::class_< PartOfMaterialFieldClass, PartOfMaterialFieldPtr >( "PartOfMaterialField",
                                                                    py::no_init )
        .def( "__init__", py::make_constructor( &initFactoryPtr< PartOfMaterialFieldClass > ) )
        .def( "__init__",
              py::make_constructor( &initFactoryPtr< PartOfMaterialFieldClass,
                                                     std::vector< MaterialPtr >, MeshEntityPtr > ) )
        .def( "getVectorOfMaterial", &PartOfMaterialFieldClass::getVectorOfMaterial )
        .def( "getMeshEntity", &PartOfMaterialFieldClass::getMeshEntity );

    void ( MaterialFieldClass::*addmat1all )( std::vector< MaterialPtr > curMaters ) =
        &MaterialFieldClass::addMaterialsOnAllMesh;
    void ( MaterialFieldClass::*addmat2all )( MaterialPtr & curMater ) =
        &MaterialFieldClass::addMaterialsOnAllMesh;

    void ( MaterialFieldClass::*addmat1grp )( std::vector< MaterialPtr > curMaters,
                                              VectorString namesOfGroup ) =
        &MaterialFieldClass::addMaterialsOnGroupOfCells;
    void ( MaterialFieldClass::*addmat2grp )( MaterialPtr & curMater, VectorString namesOfGroup ) =
        &MaterialFieldClass::addMaterialsOnGroupOfCells;

    void ( MaterialFieldClass::*addmat1cell )( std::vector< MaterialPtr > curMaters,
                                               VectorString namesOfCells ) =
        &MaterialFieldClass::addMaterialsOnCell;
    void ( MaterialFieldClass::*addmat2cell )( MaterialPtr & curMater, VectorString namesOfCells ) =
        &MaterialFieldClass::addMaterialsOnCell;

    py::class_< MaterialFieldClass, MaterialFieldClass::MaterialFieldPtr,
                py::bases< DataStructure > >( "MaterialField", py::no_init )
        .def( "__init__",
              py::make_constructor( &initFactoryPtr< MaterialFieldClass, const MeshPtr & > ) )
        .def( "__init__",
              py::make_constructor( &initFactoryPtr< MaterialFieldClass, const SkeletonPtr & > ) )
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< MaterialFieldClass, const std::string &, const MeshPtr & > ) )
#ifdef _USE_MPI
        .def( "__init__", py::make_constructor(
                              &initFactoryPtr< MaterialFieldClass, const ParallelMeshPtr & > ) )
        .def( "__init__",
              py::make_constructor( &initFactoryPtr< MaterialFieldClass, const std::string &,
                                                     const ParallelMeshPtr & > ) )
#endif /* _USE_MPI */
        .def( "addBehaviourOnAllMesh", &MaterialFieldClass::addBehaviourOnAllMesh )
        .def( "addBehaviourOnGroupOfCells", &MaterialFieldClass::addBehaviourOnGroupOfCells )
        .def( "addBehaviourOnCell", &MaterialFieldClass::addBehaviourOnCell )

        .def( "addMaterialsOnAllMesh", addmat1all )
        .def( "addMaterialsOnAllMesh", addmat2all )

        .def( "addMaterialsOnGroupOfCells", addmat1grp )
        .def( "addMaterialsOnGroupOfCells", addmat2grp )

        .def( "addMaterialsOnCell", addmat1cell )
        .def( "addMaterialsOnCell", addmat2cell )

        .def( "buildWithoutExternalVariable", &MaterialFieldClass::buildWithoutExternalVariable )
        .def( "getMesh", &MaterialFieldClass::getMesh )
        .def( "getVectorOfMaterial", &MaterialFieldClass::getVectorOfMaterial )
        .def( "getVectorOfPartOfMaterialField",
              &MaterialFieldClass::getVectorOfPartOfMaterialField )
        .def( "setModel", &MaterialFieldClass::setModel );
};
