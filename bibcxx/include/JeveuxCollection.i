%module libAster
%{
#include "JeveuxTools.hpp"
#include "JeveuxCollection.hpp"
%}

template<class ValueType>
class JeveuxCollection
{
    public:
        JeveuxCollection(char* name);
};

%template(JeveuxCollectionLong) JeveuxCollection<long>;
