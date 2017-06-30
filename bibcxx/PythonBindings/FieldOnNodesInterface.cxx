/**
 * @file FieldOnNodesInterface.cxx
 * @brief Interface python de FieldOnNodes
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "PythonBindings/DataStructureInterface.h"
#include "PythonBindings/FieldOnNodesInterface.h"
#include "DataFields/MeshCoordinatesField.h"
#include "PythonBindings/ConstViewerUtilities.h"
#include <boost/python.hpp>

void exportFieldOnNodesToPython()
{
    using namespace boost::python;

//     class_< ConstViewer< MeshCoordinatesFieldInstance > >
//         ( "MeshCoordinatesFieldConst", no_init )
// //         .def( "__getitem__", &MeshCoordinatesFieldInstance::operator[] )
//         .def( "__getitem__", +[](const ConstViewer< MeshCoordinatesFieldInstance >& v, int i)
//         {
//             const auto& o = *(v.ptr);
//             return o.operator[](i);
//         })
//         .def( "updateValuePointers", +[](const ConstViewer< MeshCoordinatesFieldInstance >& v)
//         {
//             const auto& o = *(v.ptr);
//             return o.updateValuePointers();
//         })
//     ;

    class_< FieldOnNodesDoubleInstance, FieldOnNodesDoublePtr,
            bases< DataStructure > >("FieldOnNodesDouble", no_init)
        .def( "create", &FieldOnNodesDoubleInstance::create )
        .staticmethod( "create" )
        .def( "exportToSimpleFieldOnNodes", &FieldOnNodesDoubleInstance::exportToSimpleFieldOnNodes )
//         .def( "__getitem__", &FieldOnNodesDoubleInstance::operator[] )
        .def( "__getitem__", +[](const FieldOnNodesDoubleInstance& v, int i)
        {
            return v.operator[](i);
        })
        .def( "printMedFile", &FieldOnNodesDoubleInstance::printMedFile )
        .def( "updateValuePointers", &FieldOnNodesDoubleInstance::updateValuePointers )
    ;

    to_python_converter< MeshCoordinatesFieldPtr,
                         MeshCoordinatesFieldToFieldOnNodes >();
};
