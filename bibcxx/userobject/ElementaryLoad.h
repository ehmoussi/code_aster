#ifndef ELEMENTARYLOAD_H_
#define ELEMENTARYLOAD_H_

#include "userobject/MeshEntities.h"

template< class ValueType >
class PhysicalQuantity
{
    private:
        string _name;

    public:
        typedef ValueType valueType;
        
}

/**
* struct template AllowedElementaryLoadType
*   structure permettant de limiter le type instanciable de MaterialPropertyInstance
*   on autorise 2 types pour le moment : double et complex
* @author Nicolas Sellenet
*/
template<typename T>
struct AllowedElementaryLoadType;

template<> struct AllowedElementaryLoadType< double >
{};

template<> struct AllowedElementaryLoadType< double complex >
{};

template< class PhysicalQuantityType >
class UnitaryLoadInstance: private AllowedElementaryLoadType< PhysicalQuantityType >
{
    private:
        string    _name;
        PhysicalQuantityType::valueType

    public:
        ElementaryLoad(string name): _name( name )
        {}

        void setValue(ValueType valeur)
        {
            _value = valeur;
        }
}

typedef UnitaryLoadInstance< double > DoubleLoadInstance;

class LoadInstance

#endif /* ELEMENTARYLOAD_H_ */
