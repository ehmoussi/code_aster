#ifndef FIELDONNODES_HPP_
#define FIELDONNODES_HPP_

#include <string>
#include <assert.h>

#include "baseobject/JeveuxVector.h"

template<class ValueType>
class FieldOnNodesInstance
{
    private:
        string                  _name;
        JeveuxVectorLong        _descriptor;
        JeveuxVectorChar24      _reference;
        JeveuxVector<ValueType> _valuesList;

    public:
        FieldOnNodesInstance(string name): _name(name),
                                           _descriptor( JeveuxVectorLong(string(name+".DESC")) ),
                                           _reference( JeveuxVectorChar24(string(name+".REFE")) ),
                                           _valuesList( JeveuxVector<ValueType>(string(name+".VALE")) )
        {
            assert(name.size() == 19);
        };

        const ValueType &operator[](int i) const
        {
            return _valuesList->operator[](i);
        };

        bool updateValuePointers()
        {
            _descriptor->updateValuePointer();
            _reference->updateValuePointer();
            _valuesList->updateValuePointer();
        };
};

template<class ValueType>
class FieldOnNodes
{
    public:
        typedef boost::shared_ptr< FieldOnNodesInstance< ValueType > > FieldOnNodesTypePtr;

    private:
        FieldOnNodesTypePtr _fieldOnNodesPtr;

    public:
        FieldOnNodes(string nom): _fieldOnNodesPtr( new FieldOnNodesInstance< ValueType > (nom) )
        {};

        ~FieldOnNodes()
        {};

        FieldOnNodes& operator=(const FieldOnNodes< ValueType >& tmp)
        {
            _fieldOnNodesPtr = tmp._fieldOnNodesPtr;
        };

        const FieldOnNodesTypePtr& operator->(void) const
        {
            return _fieldOnNodesPtr;
        };

        bool isEmpty() const
        {
            if ( _fieldOnNodesPtr.use_count() == 0 ) return true;
            return false;
        };
};

typedef FieldOnNodes<double> FieldOnNodesDouble;

#endif /* FIELDONNODES_HPP_ */
