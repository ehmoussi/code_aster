/* person_in_charge: mathieu.courtois@edf.fr */

#include <string>
#include <vector>
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
    // XXX: could not allocated in the constructor
    _property->allocate( "G", 6 );
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
