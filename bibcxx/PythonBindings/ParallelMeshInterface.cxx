/**
 * @file ParallelMeshInterface.cxx
 * @brief Interface python de ParallelMesh
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include <boost/python.hpp>

namespace py = boost::python;
#include <PythonBindings/factory.h>
#include "PythonBindings/ParallelMeshInterface.h"
#include "PythonBindings/factory.h"

#ifdef _USE_MPI

void exportParallelMeshToPython() {
    py::class_< ParallelMeshClass, ParallelMeshClass::ParallelMeshPtr,
                py::bases< BaseMeshClass > >( "ParallelMesh", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< ParallelMeshClass >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ParallelMeshClass, std::string >))
        .def( "hasLocalGroupOfCells", &ParallelMeshClass::hasLocalGroupOfCells )
        .def( "hasLocalGroupOfNodes", &ParallelMeshClass::hasLocalGroupOfNodes )
        .def( "updateGlobalGroupOfCells", &ParallelMeshClass::updateGlobalGroupOfCells )
        .def( "updateGlobalGroupOfNodes", &ParallelMeshClass::updateGlobalGroupOfNodes )
        .def( "readMedFile", &ParallelMeshClass::readMedFile );
};

#endif /* _USE_MPI */
