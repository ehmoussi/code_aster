%module code_aster
%{
#include "RunManager/Initializer.h"
#include "MemoryManager/JeveuxCollection.h"
%}

/* person_in_charge: nicolas.sellenet at edf.fr */

template<class ValueType>
class JeveuxCollection
{
    public:
        JeveuxCollection(char* name);
};

%template(JeveuxCollectionLong) JeveuxCollection<long>;
