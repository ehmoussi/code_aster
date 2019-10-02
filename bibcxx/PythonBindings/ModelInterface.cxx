/**
 * @file ModelInterface.cxx
 * @brief Interface python de Model
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
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

#include <boost/python.hpp>
#include <PythonBindings/factory.h>
#include "PythonBindings/ModelInterface.h"

void exportModelToPython() {
    using namespace boost::python;

    enum_< ModelSplitingMethod >( "ModelSplitingMethod" )
        .value( "Centralized", Centralized )
        .value( "SubDomain", SubDomain )
        .value( "GroupOfElements", GroupOfElementsSplit );

    enum_< GraphPartitioner >( "GraphPartitioner" ).value( "Scotch", ScotchPartitioner ).value(
        "Metis", MetisPartitioner );

    bool ( ModelInstance::*c1 )( MeshPtr & ) = &ModelInstance::setSupportMesh;
    bool ( ModelInstance::*c4 )( SkeletonPtr & ) = &ModelInstance::setSupportMesh;

    void ( ModelInstance::*split1 )( ModelSplitingMethod ) = &ModelInstance::setSplittingMethod;

    void ( ModelInstance::*split2 )( ModelSplitingMethod, GraphPartitioner ) =
        &ModelInstance::setSplittingMethod;
#ifdef _USE_MPI
    bool ( ModelInstance::*c2 )( ParallelMeshPtr & ) = &ModelInstance::setSupportMesh;
    bool ( ModelInstance::*c3 )( PartialMeshPtr & ) = &ModelInstance::setSupportMesh;
#endif /* _USE_MPI */
    bool ( ModelInstance::*c5 )( BaseMeshPtr & ) = &ModelInstance::setSupportMesh;

    class_< ModelInstance, ModelInstance::ModelPtr, bases< DataStructure > >( "Model", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< ModelInstance >))
        .def( "__init__", make_constructor(&initFactoryPtr< ModelInstance, std::string >))
        .def( "addModelingOnAllMesh", &ModelInstance::addModelingOnAllMesh )
        .def( "addModelingOnGroupOfElements", &ModelInstance::addModelingOnGroupOfElements )
        .def( "addModelingOnGroupOfNodes", &ModelInstance::addModelingOnGroupOfNodes )
        .def( "build", &ModelInstance::build )
        .def( "existsThm", &ModelInstance::existsThm )
        .def( "existsMultiFiberBeam", &ModelInstance::existsMultiFiberBeam )
        .def( "getSaneModel", &ModelInstance::getSaneModel )
        .def( "getMesh", &ModelInstance::getMesh )
        .def( "getSplittingMethod", &ModelInstance::getSplittingMethod )
        .def( "getGraphPartitioner", &ModelInstance::getGraphPartitioner )
        .def( "setSaneModel", &ModelInstance::setSaneModel )
        .def( "setSupportMesh", c1 )
        .def( "setSupportMesh", c4 )
        .def( "setSplittingMethod", split1 )
        .def( "setSplittingMethod", split2 )
#ifdef _USE_MPI
        .def( "setSupportMesh", c2 )
        .def( "setSupportMesh", c3 )
#endif /* _USE_MPI */
        .def( "setSupportMesh", c5 )
        .def( "getFiniteElementDescriptor", &ModelInstance::getFiniteElementDescriptor );
};
