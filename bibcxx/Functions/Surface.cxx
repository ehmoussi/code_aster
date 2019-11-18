/**
 * @file Surface.cxx
 * @brief Implementation de Surface
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

#include "Functions/Surface.h"
#include <boost/python.hpp>

PyObject *SurfaceInstance::exportExtensionToPython() const {
    if ( !_property->exists() )
        throw std::runtime_error( getName() + " does not exist" );

    _property->updateValuePointer();

    using namespace boost::python;
    using boost::python::list;

    list toReturn;
    for ( int pos = 0; pos < _property->size(); ++pos ) {
        const std::string toCopy = ( *_property )[pos].toString();
        toReturn.append( toCopy );
    }
    return incref( toReturn.ptr() );
};

PyObject *SurfaceInstance::exportParametersToPython() const {
    if ( !_parameters->exists() )
        throw std::runtime_error( getName() + " does not exist" );

    _parameters->updateValuePointer();

    using namespace boost::python;
    using boost::python::list;

    list toReturn;
    for ( int pos = 0; pos < _parameters->size(); ++pos ) {
        toReturn.append( ( *_parameters )[pos] );
    }
    return incref( toReturn.ptr() );
};

PyObject *SurfaceInstance::exportValuesToPython() const {
    if ( !_value->exists() )
        throw std::runtime_error( getName() + " does not exist" );

    _value->buildFromJeveux();

    using namespace boost::python;
    using boost::python::list;

    list toReturn;
    for ( const auto &curIter : *_value ) {
        const auto size = curIter.size() / 2;
        list list1;
        list list2;
        list list3;
        for ( int pos = 0; pos < size; ++pos ) {
            list2.append( curIter[pos] );
            list3.append( curIter[pos + size] );
        }
        list1.append( list2 );
        list1.append( list3 );
        toReturn.append( list1 );
    }
    return incref( toReturn.ptr() );
};
