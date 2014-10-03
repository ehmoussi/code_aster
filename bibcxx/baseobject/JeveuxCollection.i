%module code_aster
%{
#include "command/Initializer.h"
#include "baseobject/JeveuxCollection.h"
%}

/* person_in_charge: nicolas.sellenet at edf.fr */

template<class ValueType>
class JeveuxCollection
{
    public:
        JeveuxCollection(char* name);
};

%template(JeveuxCollectionLong) JeveuxCollection<long>;
