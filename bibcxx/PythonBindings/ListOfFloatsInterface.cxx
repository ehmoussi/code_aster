/**
 * @file ListOfFloatsInterface.cxx
 * @brief Interface python de ListOfFloats
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
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
#include "PythonBindings/ListOfFloatsInterface.h"

void exportListOfFloatsToPython() {

    py::class_< ListOfFloatsInstance, ListOfFloatsInstance::ListOfFloatsPtr,
                py::bases< DataStructure > >( "ListOfFloats", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< ListOfFloatsInstance >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ListOfFloatsInstance, std::string >))
        .def( "getValues", &ListOfFloatsInstance::getValues )
        .def( "setVectorValues", &ListOfFloatsInstance::setVectorValues )
        //         .def( "size", &ListOfFloatsInstance::size )
        .add_property( "size", &ListOfFloatsInstance::size );
};
