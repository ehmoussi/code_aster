#ifndef JEVEUXVECTOR_HPP_
#define JEVEUXVECTOR_HPP_

#include "definition.h"
#include "baseobject/JeveuxTools.hpp"

#include <string>

using namespace std;

template<class ValueType>
class JeveuxVectorInstance
{
    private:
        string     _name;
        ValueType* _valuePtr;

    public:
        JeveuxVectorInstance(string nom): _name(nom), _valuePtr(NULL)
        {};

        const ValueType &operator[](int i) const
        {
            return _valuePtr[i];
        };

        bool updateValuePointer()
        {
            if ( _name == "" ) return false;
            _valuePtr = NULL;

            long boolRetour;
            CALL_JEEXIN(_name.c_str(), &boolRetour);
            if ( boolRetour == 0 ) return false;

            const char* tmp = "L";
            CALL_JEVEUOC(_name.c_str(), tmp, (void*)(&_valuePtr));
            if ( _valuePtr == NULL ) return false;
            return true;
        };
};

template<class ValueType>
class JeveuxVector
{
    public:
        typedef boost::shared_ptr< JeveuxVectorInstance< ValueType > > JeveuxVectorTypePtr;

    private:
        JeveuxVectorTypePtr _jeveuxVectorPtr;

    public:
        JeveuxVector(string nom): _jeveuxVectorPtr( new JeveuxVectorInstance< ValueType > (nom) )
        {};

        ~JeveuxVector()
        {};

        JeveuxVector& operator=(const JeveuxVector< ValueType >& tmp)
        {
            _jeveuxVectorPtr = tmp._jeveuxVectorPtr;
        };

        const JeveuxVectorTypePtr& operator->(void) const
        {
            return _jeveuxVectorPtr;
        };

        bool isEmpty() const
        {
            if ( _jeveuxVectorPtr.use_count() == 0 ) return true;
            return false;
        };
};

typedef JeveuxVector<long> JeveuxVectorLong;
typedef JeveuxVector<double> JeveuxVectorDouble;
typedef JeveuxVector<char[8]> JeveuxVectorChar8;
typedef JeveuxVector<char[24]> JeveuxVectorChar24;

#endif /* JEVEUXVECTOR_HPP_ */
