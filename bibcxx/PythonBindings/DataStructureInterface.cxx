/**
 * @file DataStructureInterface.cxx
 * @brief Interface python de DataStructure
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

#include "PythonBindings/DataStructureInterface.h"
#include <boost/python.hpp>

namespace py = boost::python;

void exportDataStructureToPython() {

    void ( DataStructure::*c1 )( const int ) const = &DataStructure::debugPrint;
    void ( DataStructure::*c2 )() const = &DataStructure::debugPrint;

    py::class_< DataStructure, DataStructure::DataStructurePtr >( "DataStructure", py::no_init )
        .enable_pickling()
        // fake initFactoryPtr: created by subclasses
        // fake initFactoryPtr: created by subclasses
        .def( "addDependency", &DataStructure::addDependency,
        R"(
Add a dependency to a *DataStructure*.

Arguments:
    ds (*DataStructure*): Parent *DataStructure* to depend on.
        )",
            ( py::arg( "self" ), py::arg( "ds" ) ) )

        .def( "removeDependency", &DataStructure::removeDependency,
        R"(
Remove a dependency to a *DataStructure*.

Arguments:
    ds (*DataStructure*): Parent *DataStructure* to be removed from
        dependencies.
        )",
            ( py::arg( "self" ), py::arg( "ds" ) ) )

        .def( "getDependencies", &DataStructure::getDependencies,
        R"(
Return the explicit dependencies.

Returns:
    list[*DataStructure*]: List of parents (dependencies) *DataStructure*.
        )",
            ( py::arg( "self" ) ) )

        .def( "getName", &DataStructure::getName, py::return_value_policy< py::return_by_value >(),
        R"(
Return the internal (*Jeveux*) name of the *DataStructure*.

Returns:
    str: Internal/*Jeveux* name.
        )",
            ( py::arg( "self" ) ) )

        .add_property( "userName",
                       make_function( &DataStructure::getUserName,
                                      py::return_value_policy< py::return_by_value >() ),
                       &DataStructure::setUserName,
                       R"(
str: Name of the user variable that holds this object.
        )" )
        .def( "getType", &DataStructure::getType, py::return_value_policy< py::return_by_value >(),
        R"(
Return the name of the *DataStructure* type.

Returns:
    str: Name of the *DataStructure* type.
        )",
            ( py::arg( "self" ) ) )
        .def( "debugPrint", c1 )
        .def( "debugPrint", c2 )
        .def( "update", &DataStructure::update,
        R"(
Update the *DataStructure* attributes from the *Jeveux* objects.
*Only use internally after calling fortran subroutines*.

Returns:
    bool: *True* if all went ok, *False* otherwise.
        )",
            ( py::arg( "self" ) ) );
};

/* Don't know how to document a property (for userName):
        R"(
str: Name of the user variable that holds this object.
        )",
                                        ( py::arg( "self" ) ) ),
*/
