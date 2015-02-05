#ifndef SYNTAXDICTIONARY_H_
#define SYNTAXDICTIONARY_H_

#include <map>
#include <string>
#include <vector>
#include <list>
#include "boost/variant.hpp"
#include <typeinfo>
#include <iostream>

#include "Python.h"

struct SyntaxMapContainer;

typedef std::list< SyntaxMapContainer > ListSyntaxMapContainer;
typedef ListSyntaxMapContainer::iterator ListSyntaxMapContainerIter;

typedef std::vector< int > ListInt;
typedef ListInt::iterator ListIntIter;

typedef std::vector< std::string > ListOfString;
typedef ListOfString::iterator ListOfStringIter;

typedef std::vector< double > ListOfDouble;
typedef ListOfDouble::iterator ListOfDoubleIter;

struct SyntaxMapContainer
{
    typedef std::map< std::string, boost::variant< int, std::string, double,
                                                   ListInt, ListOfString, ListOfDouble,
                                                   ListSyntaxMapContainer > > SyntaxMap;
    typedef SyntaxMap::iterator SyntaxMapIter;

    SyntaxMap container;
    
//     void imprimer( std::string toAdd = "" );

//     template< typename listType >
//     void printValues( listType& currentList )
//     {
//         typedef typename listType::iterator listTypeIter;
//         for ( listTypeIter iter = currentList.begin();
//               iter != currentList.end();
//               ++iter )
//         {
//             std::cout << (*iter) << ", ";
//         }
//         std::cout << std::endl;
//     };

    PyObject* convertToPythonDictionnary( PyObject* returnDict = NULL );
};

#endif
