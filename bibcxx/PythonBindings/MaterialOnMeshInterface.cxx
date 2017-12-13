/**
 * @file MaterialOnMeshInterface.cxx
 * @brief Interface python de MaterialOnMesh
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2017  EDF R&D                www.code-aster.org
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

#include "PythonBindings/MaterialOnMeshInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

void exportMaterialOnMeshToPython()
{
    using namespace boost::python;

    class_< MaterialOnMeshInstance, MaterialOnMeshInstance::MaterialOnMeshPtr,
            bases< DataStructure > > ( "MaterialOnMesh", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< MaterialOnMeshInstance,
                             const MeshPtr& > ) )
        .def( "__init__", make_constructor(
            &initFactoryPtr< MaterialOnMeshInstance,
                             const SkeletonPtr& > ) )
        .def( "__init__", make_constructor(
            &initFactoryPtr< MaterialOnMeshInstance,
                             const std::string&,
                             const MeshPtr& > ) )
#ifdef _USE_MPI
        .def( "__init__", make_constructor(
            &initFactoryPtr< MaterialOnMeshInstance,
                             const ParallelMeshPtr& > ) )
        .def( "__init__", make_constructor(
            &initFactoryPtr< MaterialOnMeshInstance,
                             const std::string&,
                             const ParallelMeshPtr& > ) )
#endif /* _USE_MPI */
        .def( "addMaterialOnAllMesh", &MaterialOnMeshInstance::addMaterialOnAllMesh )
        .def( "addMaterialOnGroupOfElements",
              &MaterialOnMeshInstance::addMaterialOnGroupOfElements )
        .def( "getSupportMesh", &MaterialOnMeshInstance::getSupportMesh )
        .def( "build", &MaterialOnMeshInstance::build )
    ;
};
