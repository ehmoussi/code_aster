/**
 * @file ModelInterface.cxx
 * @brief Interface python de Model
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

#include "PythonBindings/ModelInterface.h"
#include "PythonBindings/SharedPtrUtilities.h"
#include <boost/python.hpp>

void exportModelToPython()
{
    using namespace boost::python;

//     enum_< ModelSiplitingMethod >( "ModelSiplitingMethod" )
//         .value( "Centralized", Centralized )
//         .value( "SubDomain", SubDomain )
//         .value( "GroupOfElements", GroupOfElements )
//         ;
// 
//     enum_< GraphPartitioner >( "GraphPartitioner" )
//         .value( "Scotch", ScotchPartitioner )
//         .value( "Metis", MetisPartitioner )
//         ;

    bool (ModelInstance::*c1)(MeshPtr&) =
            &ModelInstance::setSupportMesh;
#ifdef _USE_MPI
    bool (ModelInstance::*c2)(ParallelMeshPtr&) =
            &ModelInstance::setSupportMesh;
#endif /* _USE_MPI */

    class_< ModelInstance, ModelInstance::ModelPtr,
            bases< DataStructure > > ( "Model", no_init )
        .def( "create", &createSharedPtr< ModelInstance > )
        .staticmethod( "create" )
        .def( "addModelingOnAllMesh", &ModelInstance::addModelingOnAllMesh )
        .def( "addModelingOnGroupOfElements", &ModelInstance::addModelingOnGroupOfElements )
        .def( "addModelingOnGroupOfNodes", &ModelInstance::addModelingOnGroupOfNodes )
        .def( "build", &ModelInstance::build )
        .def( "getSupportMesh", &ModelInstance::getSupportMesh )
        .def( "setSupportMesh", c1 )
#ifdef _USE_MPI
        .def( "setSupportMesh", c2 )
#endif /* _USE_MPI */
    ;
};