/**
 * @file SyntaxDictionary.cxx
 * @brief Implementation de SyntaxMapContainer
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

#include "Utilities/SyntaxDictionary.h"

PyObject *SyntaxMapContainer::convertToPythonDictionnary( PyObject *returnDict ) const {
    if ( returnDict == NULL )
        returnDict = PyDict_New();

    for ( SyntaxMapCIter curIter = container.begin(); curIter != container.end(); ++curIter ) {
        if ( ( *curIter ).second.type() == typeid( ASTERINTEGER ) ) {
            const ASTERINTEGER &tmp = boost::get< ASTERINTEGER >( ( *curIter ).second );
            PyDict_SetItemString( returnDict, ( *curIter ).first.c_str(), PyLong_FromLong( tmp ) );
        } else if ( ( *curIter ).second.type() == typeid( VectorLong ) ) {
            const VectorLong &currentList = boost::get< VectorLong >( ( *curIter ).second );
            PyObject *listValues = PyList_New( currentList.size() );
            int count = 0;
            for ( VectorLongCIter iter = currentList.begin(); iter != currentList.end(); ++iter ) {
                PyList_SetItem( listValues, count, PyLong_FromLong( *iter ) );
                ++count;
            }
            PyDict_SetItemString( returnDict, ( *curIter ).first.c_str(), listValues );
        } else if ( ( *curIter ).second.type() == typeid( std::string ) ) {
            const std::string &tmp = boost::get< std::string >( ( *curIter ).second );
            PyDict_SetItemString( returnDict, ( *curIter ).first.c_str(),
                                  PyUnicode_FromString( tmp.c_str() ) );
        } else if ( ( *curIter ).second.type() == typeid( VectorString ) ) {
            const VectorString &currentList = boost::get< VectorString >( ( *curIter ).second );
            PyObject *listValues = PyList_New( currentList.size() );
            int count = 0;
            for ( VectorStringCIter iter = currentList.begin(); iter != currentList.end();
                  ++iter ) {
                PyList_SetItem( listValues, count, PyUnicode_FromString( ( *iter ).c_str() ) );
                ++count;
            }
            PyDict_SetItemString( returnDict, ( *curIter ).first.c_str(), listValues );
        } else if ( ( *curIter ).second.type() == typeid(double)) {
            const double &tmp = boost::get< double >( ( *curIter ).second );
            PyDict_SetItemString( returnDict, ( *curIter ).first.c_str(),
                                  PyFloat_FromDouble( tmp ) );
        } else if ( ( *curIter ).second.type() == typeid( VectorReal ) ) {
            const VectorReal &currentList = boost::get< VectorReal >( ( *curIter ).second );
            PyObject *listValues = PyList_New( currentList.size() );
            int count = 0;
            for ( VectorRealCIter iter = currentList.begin(); iter != currentList.end();
                  ++iter ) {
                PyList_SetItem( listValues, count, PyFloat_FromDouble( *iter ) );
                ++count;
            }
            PyDict_SetItemString( returnDict, ( *curIter ).first.c_str(), listValues );
        } else if ( ( *curIter ).second.type() == typeid( RealComplex ) ) {
            const RealComplex &tmp = boost::get< RealComplex >( ( *curIter ).second );
            PyDict_SetItemString( returnDict, ( *curIter ).first.c_str(),
                                  PyComplex_FromDoubles( tmp.real(), tmp.imag() ) );
        } else if ( ( *curIter ).second.type() == typeid( VectorComplex ) ) {
            const VectorComplex &currentList = boost::get< VectorComplex >( ( *curIter ).second );
            PyObject *listValues = PyList_New( currentList.size() );
            int count = 0;
            for ( VectorComplexCIter iter = currentList.begin(); iter != currentList.end();
                  ++iter ) {
                PyList_SetItem( listValues, count,
                                PyComplex_FromDoubles( iter->real(), iter->imag() ) );
                ++count;
            }
            PyDict_SetItemString( returnDict, ( *curIter ).first.c_str(), listValues );
        } else if ( ( *curIter ).second.type() == typeid( ListSyntaxMapContainer ) ) {
            const ListSyntaxMapContainer &tmp =
                boost::get< ListSyntaxMapContainer >( ( *curIter ).second );
            PyObject *list_F = PyList_New( tmp.size() );
            int count = 0;
            for ( ListSyntaxMapContainerCIter iter2 = tmp.begin(); iter2 != tmp.end(); ++iter2 ) {
                PyObject *currentDict = iter2->convertToPythonDictionnary();
                PyList_SetItem( list_F, count, currentDict );
                ++count;
            }
            PyDict_SetItemString( returnDict, ( *curIter ).first.c_str(), list_F );
        }
    }
    return returnDict;
};

SyntaxMapContainer operator+( const SyntaxMapContainer &toAdd1, const SyntaxMapContainer &toAdd2 ) {
    SyntaxMapContainer retour = toAdd1;
    retour += toAdd2;
    return retour;
};
