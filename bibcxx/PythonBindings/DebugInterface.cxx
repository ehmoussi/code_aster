/**
 * @file DebugInterface.cxx
 * @brief Python interface for debugging
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

#include <string>
#include <boost/python.hpp>

namespace py = boost::python;

#include "astercxx.h"
#include "aster_fort_jeveux.h"

#include "Meshes/Mesh.h"
#include "Modeling/Model.h"
#include "Numbering/DOFNumbering.h"
#include "LinearAlgebra/AssemblyMatrix.h"
#include "LinearAlgebra/ElementaryMatrix.h"

#include "PythonBindings/DebugInterface.h"

static void libaster_debugJeveuxContent( const std::string message ) {
    ASTERINTEGER unit_out = 6;
    std::string base( "G" );
    CALLO_JEIMPR( &unit_out, base, message );
};

void exportDebugToPython() {

    py::def( "debugJeveuxContent", &libaster_debugJeveuxContent );
    py::def( "use_count", &libaster_debugRefCount< MeshPtr > );
    py::def( "use_count", &libaster_debugRefCount< ModelPtr > );
    py::def( "use_count", &libaster_debugRefCount< DOFNumberingPtr > );
    py::def( "use_count", &libaster_debugRefCount< ElementaryMatrixDisplacementRealPtr > );
    py::def( "use_count", &libaster_debugRefCount< ElementaryMatrixDisplacementComplexPtr > );
    py::def( "use_count", &libaster_debugRefCount< ElementaryMatrixTemperatureRealPtr > );
    py::def( "use_count", &libaster_debugRefCount< ElementaryMatrixPressureComplexPtr > );
    py::def( "use_count", &libaster_debugRefCount< AssemblyMatrixDisplacementRealPtr > );
    py::def( "use_count", &libaster_debugRefCount< AssemblyMatrixDisplacementComplexPtr > );
    py::def( "use_count", &libaster_debugRefCount< AssemblyMatrixTemperatureRealPtr > );
    py::def( "use_count", &libaster_debugRefCount< AssemblyMatrixTemperatureComplexPtr > );
    py::def( "use_count", &libaster_debugRefCount< AssemblyMatrixPressureRealPtr > );
    py::def( "use_count", &libaster_debugRefCount< AssemblyMatrixPressureComplexPtr > );
};
