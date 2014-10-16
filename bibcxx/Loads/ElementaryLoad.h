#ifndef ELEMENTARYLOAD_H_
#define ELEMENTARYLOAD_H_

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
