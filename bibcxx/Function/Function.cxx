/* person_in_charge: mathieu.courtois@edf.fr */

#include <string>
#include <vector>

#include "astercxx.h"
#include "Function/Function.h"


FunctionInstance::FunctionInstance():
    DataStructure( initAster->getNewResultObjectName(), "FONCTION" ),
    _jeveuxName( initAster->getResultObjectName() ),
    _property( JeveuxVectorChar16( _jeveuxName + ".PROL           " ) ),
    _value( JeveuxVectorDouble( _jeveuxName + ".VALE           " ) )
{}

void FunctionInstance::setValues( const VectorDouble &absc, const VectorDouble &ord )
{
    if ( absc.size() != ord.size() )
        throw "Function: length of abscissa and ordinates must be equal";
    _absc = absc;
    _ord = ord;
}

bool FunctionInstance::build()
{
    // Create Jeveux vector ".PROL"
    // XXX: could be allocated in the constructor
    _property->allocate( "G", 6 );
//     CopyStringToFStr( (*_property)[0], "FONCTION", 16 );
//     CopyStringToFStr( (*_property)[1], "LIN LIN", 16 );
//     CopyStringToFStr( (*_property)[2], _parameterName.c_str(), 16 );
//     CopyStringToFStr( (*_property)[3], _resultName.c_str(), 16 );
//     CopyStringToFStr( (*_property)[4], "EE", 16 );
//     CopyStringToFStr( (*_property)[5], _jeveuxName.c_str(), 16 );

    (*_property)[0] = "FONCTION";
    (*_property)[1] = "LIN LIN";
    (*_property)[2] = _parameterName.c_str();
    (*_property)[3] = _resultName.c_str();
    (*_property)[4] = "EE";
    (*_property)[5] = _jeveuxName.c_str();

    // Create Jeveux vector ".VALE"
    const int nbpts = _absc.size();
    _value->allocate( "G", 2 * nbpts );

    // Loop on the points
    VectorDouble::iterator abscIt = _absc.begin();
    VectorDouble::iterator ordIt = _ord.begin();
    int idx = 0;
    for ( ; abscIt != _absc.end(); ++abscIt, ++ordIt )
    {
        (*_value)[idx] = *abscIt;
        ++idx;
        (*_value)[idx] = *ordIt;
        ++idx;
    }
    return true;
}
