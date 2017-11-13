/**
 * @file ElementaryMatrixInterface.cxx
 * @brief Interface python de ElementaryMatrix
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

#include <boost/python.hpp>
#include <PythonBindings/factory.h>
#include "PythonBindings/ElementaryMatrixInterface.h"


/** @brief Pickler class that defines a `__getinitargs__` method to allow
 *  to recreate an ElementaryMatrix after unpickling.
 */
struct ElementaryMatrix_pickler: boost::python::pickle_suite
{
    static boost::python::tuple getinitargs(ElementaryMatrixInstance const& ds)
    {
        return boost::python::make_tuple(ds.getName(), ds.getType());
    }
};

void exportElementaryMatrixToPython()
{
    using namespace boost::python;

    class_< ElementaryMatrixInstance, ElementaryMatrixInstance::ElementaryMatrixPtr,
            bases< DataStructure > > ( "ElementaryMatrix", no_init )
        .def_pickle(ElementaryMatrix_pickler())
        .def( "__init__", make_constructor(
            &initFactoryPtr< ElementaryMatrixInstance >) )
        .def( "__init__", make_constructor(
            &initFactoryPtr< ElementaryMatrixInstance,
                             std::string >) )
        .def( "__init__", make_constructor(
            &initFactoryPtr< ElementaryMatrixInstance,
                             std::string,
                             std::string >) )
    ;
};
