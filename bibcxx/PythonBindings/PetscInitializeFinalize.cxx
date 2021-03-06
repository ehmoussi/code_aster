/**
 * @file MPIInfosInterface.cxx
 * @brief Interface python de MPIInfos
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

#include "PythonBindings/PetscInitializeFinalize.h"

void exportPetscInitializeFinalizeToPython() {

    py::def( "petscFinalize", petscFinalize, R"(
Stops the PETSc interface.
        )");
//
    py::def( "_petscInitializeWithOptions", petscInitializeWithOptions, R"(
Starts the PETSc interface with options.

Arguments:
    options[str]: PETSc options

        )",
        ( py::args( "options" ) ) );
};
