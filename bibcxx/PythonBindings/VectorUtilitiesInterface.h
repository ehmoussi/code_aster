#ifndef VECTORUTILITIES_H_
#define VECTORUTILITIES_H_

/**
 * @file VectorUtilitiesInterface.h
 * @brief Utilitaires pour convertir un vector en list et inversement
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

#include <boost/python.hpp>

#include "astercxx.h"
#include "MemoryManager/JeveuxVector.h"

namespace py = boost::python;


template < typename T > struct VectorToPythonList {
    static PyObject *convert( std::vector< T > const &v ) {
        py::list blst;
        typename std::vector< T >::const_iterator p;
        for ( p = v.begin(); p != v.end(); ++p ) {
            blst.append( py::object( *p ) );
        }
        return py::incref( blst.ptr() );
    }
};

template < typename T > struct JeveuxVectorToPythonList {
    static PyObject *convert( JeveuxVector< T > const &v ) {
        py::list blst;
        v->updateValuePointer();
        for ( int i = 0; i < v->size(); ++i ) {
            blst.append( py::object( (*v)[i] ) );
        }
        return py::incref( blst.ptr() );
    }
};

template < typename T > struct VectorFromPythonList {
    VectorFromPythonList() {
        py::converter::registry::push_back(
            &VectorFromPythonList< T >::convertible,
            &VectorFromPythonList< T >::construct,
            py::type_id< std::vector< T > >() );
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
                           py::converter::rvalue_from_python_stage1_data *data ) {
        py::list blst( py::handle<>( py::borrowed( obj_ptr ) ) );

        // Grab pointer to memory into which to construct the new std::vector<T>
        void *storage =
            ( (py::converter::rvalue_from_python_storage< std::vector< T > > *)data )
                ->storage.bytes;

        // in-place construct the new std::vector<T> using the character data
        // extracted from the python object
        std::vector< T > &v = *( new ( storage ) std::vector< T >() );

        // populate the vector from list contains !!!
        int le = py::len( blst );
        v.resize( le );
        bool error = false;
        int count = 0;
        try {
            for ( int i = 0; i != le; ++i ) {
                v[i] = py::extract< T >( blst[i] );
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

template < class T > void exportVectorConverter() {

    // register the to-python converter
    py::to_python_converter< std::vector< T >, VectorToPythonList< T > >();

    // register the from-python converter
    VectorFromPythonList< T >();
};

template < class T > void exportJeveuxVectorConverter() {

    // register the to-python converter
    py::to_python_converter< JeveuxVector< T >, JeveuxVectorToPythonList< T > >();

};

void exportVectorUtilitiesToPython();


#endif /* VECTORUTILITIES_H_ */
