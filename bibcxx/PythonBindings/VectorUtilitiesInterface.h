#ifndef VECTORUTILITIES_H_
#define VECTORUTILITIES_H_

/**
 * @file VectorUtilitiesInterface.h
 * @brief Utilitaires pour convertir un vector en list et inversement
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

#include "astercxx.h"
#include <boost/python.hpp>

template < typename T > struct Vector_to_python_list {
    static PyObject *convert( std::vector< T > const &v ) {
        using namespace std;
        using namespace boost::python;
        using boost::python::list;
        list blst;
        typename vector< T >::const_iterator p;
        for ( p = v.begin(); p != v.end(); ++p ) {
            blst.append( object( *p ) );
        }
        return incref( blst.ptr() );
    }
};

template < typename T > struct Vector_from_python_list {
    Vector_from_python_list() {
        using namespace boost::python;
        using namespace boost::python::converter;
        registry::push_back( &Vector_from_python_list< T >::convertible,
                             &Vector_from_python_list< T >::construct,
                             type_id< std::vector< T > >() );
    }

    // Determine if obj_ptr can be converted in a std::vector<T>
    static void *convertible( PyObject *obj_ptr ) {
        if ( !PyList_Check( obj_ptr ) ) {
            return 0;
        }
        return obj_ptr;
    }

    // Convert obj_ptr into a std::vector<T>
    static void construct( PyObject *obj_ptr,
                           boost::python::converter::rvalue_from_python_stage1_data *data ) {
        using namespace boost::python;
        // Extract the character data from the python string
        //      const char* value = PyUnicode_AsString(obj_ptr);
        list blst( handle<>( borrowed( obj_ptr ) ) );

        // // Verify that obj_ptr is a string (should be ensured by convertible())
        // assert(value);

        // Grab pointer to memory into which to construct the new std::vector<T>
        void *storage =
            ( (boost::python::converter::rvalue_from_python_storage< std::vector< T > > *)data )
                ->storage.bytes;

        // in-place construct the new std::vector<T> using the character data
        // extraced from the python object
        std::vector< T > &v = *( new ( storage ) std::vector< T >() );

        // populate the vector from list contains !!!
        int le = len( blst );
        v.resize( le );
        bool error = false;
        int count = 0;
        try {
            for ( int i = 0; i != le; ++i ) {
                v[i] = extract< T >( blst[i] );
                count += 1;
            }
        } catch ( ... ) {
            error = true;
        }

        // Stash the memory chunk pointer for later use by boost.python
        data->convertible = storage;

        if ( error ) {
            v.resize( count );
            throw std::runtime_error( "Conversion error" );
        }
    }
};

template < class T > void exportVectorUtilities() {
    using namespace boost::python;

    // register the to-python converter
    to_python_converter< std::vector< T >, Vector_to_python_list< T > >();

    // register the from-python converter
    Vector_from_python_list< T >();
};

void exportVectorUtilitiesToPython();

#endif /* VECTORUTILITIES_H_ */
