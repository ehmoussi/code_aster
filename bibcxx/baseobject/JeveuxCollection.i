%module code_aster
%{
#include "command/Initializer.h"
#include "baseobject/JeveuxCollection.h"
%}

template<class ValueType>
class JeveuxCollection
{
    public:
        JeveuxCollection(char* name);
};

%template(JeveuxCollectionLong) JeveuxCollection<long>;
