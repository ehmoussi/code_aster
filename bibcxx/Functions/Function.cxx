/* person_in_charge: mathieu.courtois@edf.fr */

#include <stdexcept>
#include <string>
#include <vector>

#include "astercxx.h"
#include "Functions/Function.h"


FunctionInstance::FunctionInstance( const std::string jeveuxName ):
    DataStructure( jeveuxName + "           ", "FONCTION" ),
    _jeveuxName( getName() ),
    _property( JeveuxVectorChar24( getName() + ".PROL" ) ),
    _value( JeveuxVectorDouble( getName() + ".VALE" ) )
{
}

FunctionInstance::FunctionInstance() :
    FunctionInstance::FunctionInstance( getNewResultObjectName() )
{
}

void FunctionInstance::setValues( const VectorDouble &absc, const VectorDouble &ord ) throw ( std::runtime_error )
{
    if ( absc.size() != ord.size() )
        throw std::runtime_error( "Function: length of abscissa and ordinates must be equal" );

    // Create Jeveux vector ".VALE"
    const int nbpts = absc.size();
    _value->allocate( Permanent, 2 * nbpts );

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
