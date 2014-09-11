%module libAster
%{
#include "baseobject/JeveuxTools.hpp"
#include "baseobject/JeveuxCollection.hpp"
%}

template<class ValueType>
class JeveuxCollection
{
    public:
        JeveuxCollection(char* name);
};

%template(JeveuxCollectionLong) JeveuxCollection<long>;
