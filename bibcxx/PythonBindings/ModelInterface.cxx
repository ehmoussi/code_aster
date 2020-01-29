/**
 * @file ModelInterface.cxx
 * @brief Interface python de Model
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

#include <boost/python.hpp>

namespace py = boost::python;
#include <PythonBindings/factory.h>
#include "PythonBindings/ModelInterface.h"

void exportModelToPython() {

    py::enum_< ModelSplitingMethod >( "ModelSplitingMethod" )
        .value( "Centralized", Centralized )
        .value( "SubDomain", SubDomain )
        .value( "GroupOfElements", GroupOfElementsSplit );

    py::enum_< GraphPartitioner >( "GraphPartitioner" ).value( "Scotch", ScotchPartitioner ).value(
        "Metis", MetisPartitioner );

    bool ( ModelClass::*c1 )( MeshPtr & ) = &ModelClass::setMesh;
    bool ( ModelClass::*c4 )( SkeletonPtr & ) = &ModelClass::setMesh;

    void ( ModelClass::*split1 )( ModelSplitingMethod ) = &ModelClass::setSplittingMethod;

    void ( ModelClass::*split2 )( ModelSplitingMethod, GraphPartitioner ) =
        &ModelClass::setSplittingMethod;
#ifdef _USE_MPI
    bool ( ModelClass::*c2 )( ParallelMeshPtr & ) = &ModelClass::setMesh;
    bool ( ModelClass::*c3 )( PartialMeshPtr & ) = &ModelClass::setMesh;
#endif /* _USE_MPI */
    bool ( ModelClass::*c5 )( BaseMeshPtr & ) = &ModelClass::setMesh;

    py::class_< ModelClass, ModelClass::ModelPtr, py::bases< DataStructure > >( "Model",
                                                                                      py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< ModelClass >))
        .def( "__init__", py::make_constructor(&initFactoryPtr< ModelClass, std::string >))
        .def( "addModelingOnAllMesh", &ModelClass::addModelingOnAllMesh )
        .def( "addModelingOnGroupOfElements", &ModelClass::addModelingOnGroupOfElements )
        .def( "addModelingOnGroupOfNodes", &ModelClass::addModelingOnGroupOfNodes )
        .def( "build", &ModelClass::build )
        .def( "existsThm", &ModelClass::existsThm )
        .def( "existsMultiFiberBeam", &ModelClass::existsMultiFiberBeam )
        .def( "getSaneModel", &ModelClass::getSaneModel )
        .def( "getMesh", &ModelClass::getMesh )
        .def( "getSplittingMethod", &ModelClass::getSplittingMethod )
        .def( "getGraphPartitioner", &ModelClass::getGraphPartitioner )
        .def( "setSaneModel", &ModelClass::setSaneModel )
        .def( "setMesh", c1 )
        .def( "setMesh", c4 )
        .def( "setSplittingMethod", split1 )
        .def( "setSplittingMethod", split2 )
#ifdef _USE_MPI
        .def( "setMesh", c2 )
        .def( "setMesh", c3 )
#endif /* _USE_MPI */
        .def( "setMesh", c5 )
        .def( "getFiniteElementDescriptor", &ModelClass::getFiniteElementDescriptor );
};
