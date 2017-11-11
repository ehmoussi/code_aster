/**
 * @file DataStructureInterface.cxx
 * @brief Interface python de DataStructure
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
#include <boost/python.hpp>

/** @brief Pickler class that defines a `__getinitargs__` method to allow
 *  to recreate DataStructure after unpickling.
 */
struct DataStructure_pickler: boost::python::pickle_suite
{
    static boost::python::tuple getinitargs(DataStructure const& ds)
    {
        return boost::python::make_tuple(ds.getName());
    }
};


void exportDataStructureToPython()
{
    using namespace boost::python;

    void (DataStructure::*c1)(const int) const = &DataStructure::debugPrint;
    void (DataStructure::*c2)() const = &DataStructure::debugPrint;

    class_< DataStructure, DataStructure::DataStructurePtr >( "DataStructure", no_init )
        .def_pickle(DataStructure_pickler())
        .def( "getName", &DataStructure::getName, return_value_policy<return_by_value>() )
        .def( "getType", &DataStructure::getType, return_value_policy<return_by_value>() )
        .def( "debugPrint", c1 )
        .def( "debugPrint", c2 )
    ;
};
