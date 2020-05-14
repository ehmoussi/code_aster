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
        .value( "GroupOfCells", GroupOfCellsSplit );

    py::enum_< GraphPartitioner >( "GraphPartitioner" ).value( "Scotch", ScotchPartitioner ).value(
        "Metis", MetisPartitioner );


    void ( ModelClass::*split1 )( ModelSplitingMethod ) = &ModelClass::setSplittingMethod;

    void ( ModelClass::*split2 )( ModelSplitingMethod, GraphPartitioner ) =
        &ModelClass::setSplittingMethod;

    py::class_< ModelClass, ModelClass::ModelPtr, py::bases< DataStructure > >( "Model",
                                                                                 py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< ModelClass, BaseMeshPtr>))
        .def( "__init__", py::make_constructor(&initFactoryPtr< ModelClass, std::string,
                                                                BaseMeshPtr>))
#ifdef _USE_MPI
        .def( "__init__", py::make_constructor(&initFactoryPtr< ModelClass, ConnectionMeshPtr>))
        .def( "__init__", py::make_constructor(&initFactoryPtr< ModelClass, std::string,
                                                                            ConnectionMeshPtr>))
#endif /* _USE_MPI */
        .def( "addModelingOnAllMesh", &ModelClass::addModelingOnAllMesh )
        .def( "addModelingOnGroupOfCells", &ModelClass::addModelingOnGroupOfCells )
        .def( "addModelingOnGroupOfNodes", &ModelClass::addModelingOnGroupOfNodes )
        .def( "build", &ModelClass::build )
        .def( "existsThm", &ModelClass::existsThm )
        .def( "existsMultiFiberBeam", &ModelClass::existsMultiFiberBeam )
        .def( "getSaneModel", &ModelClass::getSaneModel )
        .def( "getMesh", &ModelClass::getMesh, R"(
Return the mesh

Returns:
    MeshPtr: a pointer to the mesh
        )",
              ( py::arg( "self" ) )  )
        .def( "getSplittingMethod", &ModelClass::getSplittingMethod )
        .def( "getGraphPartitioner", &ModelClass::getGraphPartitioner )
        .def( "setSaneModel", &ModelClass::setSaneModel )
        .def( "setSplittingMethod", split1 )
        .def( "setSplittingMethod", split2 )
        .def( "getFiniteElementDescriptor", &ModelClass::getFiniteElementDescriptor );
};
