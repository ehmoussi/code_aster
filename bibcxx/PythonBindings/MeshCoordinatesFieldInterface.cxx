/**
 * @file exportMeshCoordinatesFieldToPython.cxx
 * @brief Interface python de MeshCoordinates
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2018  EDF R&D                www.code-aster.org
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "PythonBindings/DataStructureInterface.h"
#include "PythonBindings/MeshCoordinatesFieldInterface.h"
#include "DataFields/MeshCoordinatesField.h"
#include <boost/python.hpp>

void exportMeshCoordinatesFieldToPython() {
    using namespace boost::python;

    class_< MeshCoordinatesFieldInstance, MeshCoordinatesFieldPtr, bases< DataStructure > >(
        "MeshCoordinatesField", no_init )
        .def( "__getitem__",
              +[]( const MeshCoordinatesFieldInstance &v, int i ) { return v.operator[]( i ); } );
};
