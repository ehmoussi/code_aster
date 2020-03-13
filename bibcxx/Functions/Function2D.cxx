/**
 * @file Function2D.cxx
 * @brief Implementation de Function2D
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

#include "Functions/Function2D.h"
#include <boost/python.hpp>

namespace py = boost::python;

PyObject *Function2DClass::exportExtensionToPython() const {
    if ( !_property->exists() )
        throw std::runtime_error( getName() + " does not exist" );

    _property->updateValuePointer();

    py::list toReturn;
    for ( int pos = 0; pos < _property->size(); ++pos ) {
        const std::string toCopy = ( *_property )[pos].toString();
        toReturn.append( toCopy );
    }
    return py::incref( toReturn.ptr() );
};

PyObject *Function2DClass::exportParametersToPython() const {
    if ( !_parameters->exists() )
        throw std::runtime_error( getName() + " does not exist" );

    _parameters->updateValuePointer();

    py::list toReturn;
    for ( int pos = 0; pos < _parameters->size(); ++pos ) {
        toReturn.append( ( *_parameters )[pos] );
    }
    return py::incref( toReturn.ptr() );
};

PyObject *Function2DClass::exportValuesToPython() const {
    if ( !_value->exists() )
        throw std::runtime_error( getName() + " does not exist" );

    _value->buildFromJeveux();

    py::list toReturn;
    for ( const auto &curIter : *_value ) {
        const auto size = curIter.size() / 2;
        py::list list1;
        py::list list2;
        py::list list3;
        for ( int pos = 0; pos < size; ++pos ) {
            list2.append( curIter[pos] );
            list3.append( curIter[pos + size] );
        }
        list1.append( list2 );
        list1.append( list3 );
        toReturn.append( list1 );
    }
    return py::incref( toReturn.ptr() );
};
