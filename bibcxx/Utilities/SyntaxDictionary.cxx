
#include "Utilities/SyntaxDictionary.h"

// void SyntaxMapContainer::imprimer( std::string toAdd )
// {
//     for( SyntaxMapIter curIter = container.begin();
//             curIter != container.end();
//             ++curIter )
//     {
//         if ( (*curIter).second.type() == typeid( int ) )
//         {
//             int& tmp = boost::get< int >( (*curIter).second );
//             std::cout << toAdd << (*curIter).first << " " << tmp << std::endl;
//         }
//         else if ( (*curIter).second.type() == typeid( ListInt ) )
//         {
//             std::cout << toAdd << (*curIter).first << " ";
//             printValues< ListInt >( boost::get< ListInt >( (*curIter).second ) );
//         }
//         else if ( (*curIter).second.type() == typeid( std::string ) )
//         {
//             std::string& tmp = boost::get< std::string >( (*curIter).second );
//             std::cout << toAdd << (*curIter).first << " " << tmp << std::endl;
//         }
//         else if ( (*curIter).second.type() == typeid( ListOfString ) )
//         {
//             std::cout << toAdd << (*curIter).first << " ";
//             printValues< ListOfString >( boost::get< ListOfString >( (*curIter).second ) );
//         }
//         else if ( (*curIter).second.type() == typeid( double ) )
//         {
//             double& tmp = boost::get< double >( (*curIter).second );
//             std::cout << toAdd << (*curIter).first << " " << tmp << std::endl;
//         }
//         else if ( (*curIter).second.type() == typeid( ListOfDouble ) )
//         {
//             std::cout << toAdd << (*curIter).first << " ";
//             printValues< ListOfDouble >( boost::get< ListOfDouble >( (*curIter).second ) );
//         }
//         else if ( (*curIter).second.type() == typeid( ListSyntaxMapContainer ) )
//         {
//             ListSyntaxMapContainer& tmp = boost::get< ListSyntaxMapContainer >( (*curIter).second );
//             std::cout << (*curIter).first << std::endl;
//             for ( ListSyntaxMapContainerIter iter2 = tmp.begin();
//                     iter2 != tmp.end();
//                     ++iter2 )
//             {
//                 iter2->imprimer( "\t" );
//             }
//         }
//     }
// };

PyObject* SyntaxMapContainer::convertToPythonDictionnary( PyObject* returnDict )
{
    if ( returnDict == NULL ) returnDict = PyDict_New();

    for( SyntaxMapIter curIter = container.begin();
         curIter != container.end();
         ++curIter )
    {
        if ( (*curIter).second.type() == typeid( int ) )
        {
            int& tmp = boost::get< int >( (*curIter).second );
            PyDict_SetItemString( returnDict, (*curIter).first.c_str(), PyLong_FromLong( tmp ) );
        }
        else if ( (*curIter).second.type() == typeid( ListInt ) )
        {
            ListInt& currentList = boost::get< ListInt >( (*curIter).second );
            PyObject* listValues = PyList_New( currentList.size() );
            int count = 0;
            for ( ListIntIter iter = currentList.begin();
                  iter != currentList.end();
                  ++iter )
            {
                PyList_SetItem( listValues, count, PyLong_FromLong( *iter ) );
                ++count;
            }
            PyDict_SetItemString( returnDict, (*curIter).first.c_str(), listValues );
        }
        else if ( (*curIter).second.type() == typeid( std::string ) )
        {
            std::string& tmp = boost::get< std::string >( (*curIter).second );
            PyDict_SetItemString( returnDict, (*curIter).first.c_str(),
                                  PyString_FromString( tmp.c_str() ) );
        }
        else if ( (*curIter).second.type() == typeid( ListOfString ) )
        {
            ListOfString& currentList = boost::get< ListOfString >( (*curIter).second );
            PyObject* listValues = PyList_New( currentList.size() );
            int count = 0;
            for ( ListOfStringIter iter = currentList.begin();
                  iter != currentList.end();
                  ++iter )
            {
                PyList_SetItem( listValues, count,
                                PyString_FromString( (*iter).c_str() ) );
                ++count;
            }
            PyDict_SetItemString( returnDict, (*curIter).first.c_str(), listValues );
        }
        else if ( (*curIter).second.type() == typeid( double ) )
        {
            double& tmp = boost::get< double >( (*curIter).second );
            PyDict_SetItemString( returnDict, (*curIter).first.c_str(), PyFloat_FromDouble( tmp ) );
        }
        else if ( (*curIter).second.type() == typeid( ListOfDouble ) )
        {
            ListOfDouble& currentList = boost::get< ListOfDouble >( (*curIter).second );
            PyObject* listValues = PyList_New( currentList.size() );
            int count = 0;
            for ( ListOfDoubleIter iter = currentList.begin();
                  iter != currentList.end();
                  ++iter )
            {
                PyList_SetItem( listValues, count, PyFloat_FromDouble( *iter ) );
                ++count;
            }
            PyDict_SetItemString( returnDict, (*curIter).first.c_str(), listValues );
        }
        else if ( (*curIter).second.type() == typeid( ListSyntaxMapContainer ) )
        {
            ListSyntaxMapContainer& tmp = boost::get< ListSyntaxMapContainer >( (*curIter).second );
            PyObject* list_F = PyList_New( tmp.size() );
            int count = 0;
            for ( ListSyntaxMapContainerIter iter2 = tmp.begin();
                  iter2 != tmp.end();
                  ++iter2 )
            {
                PyObject* currentDict = iter2->convertToPythonDictionnary();
                PyList_SetItem( list_F, count, currentDict );
                ++count;
            }
            PyDict_SetItemString( returnDict, (*curIter).first.c_str(), list_F );
        }
    }
    return NULL;
};
