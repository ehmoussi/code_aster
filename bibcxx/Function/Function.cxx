/* person_in_charge: mathieu.courtois@edf.fr */

#include <stdexcept>
#include <string>
#include <vector>

#include "astercxx.h"
#include "Function/Function.h"


FunctionInstance::FunctionInstance():
    DataStructure( getNewResultObjectName(), "FONCTION" ),
    _jeveuxName( getResultObjectName() ),
    _property( JeveuxVectorChar16( _jeveuxName + ".PROL           " ) ),
    _value( JeveuxVectorDouble( _jeveuxName + ".VALE           " ) )
{
    // Create Jeveux vector ".PROL"
    _property->allocate( "G", 6 );
    (*_property)[0] = "FONCTION";
    (*_property)[1] = "LIN LIN";
    (*_property)[1] = "";
    (*_property)[3] = "TOUTRESU";
    (*_property)[4] = "EE";
    (*_property)[5] = _jeveuxName.c_str();
}

void FunctionInstance::setValues( const VectorDouble &absc, const VectorDouble &ord ) throw ( std::runtime_error )
{
    if ( absc.size() != ord.size() )
        throw std::runtime_error( "Function: length of abscissa and ordinates must be equal" );

    // Create Jeveux vector ".VALE"
    const int nbpts = absc.size();
    _value->allocate( "G", 2 * nbpts );

    // Loop on the points
    VectorDouble::const_iterator abscIt = absc.begin();
    VectorDouble::const_iterator ordIt = ord.begin();
    int idx = 0;
    for ( ; abscIt != absc.end(); ++abscIt, ++ordIt )
    {
        (*_value)[idx] = *abscIt;
        ++idx;
        (*_value)[idx] = *ordIt;
        ++idx;
    }
}
