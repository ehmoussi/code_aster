#ifndef UNITARYLOAD_H_
#define UNITARYLOAD_H_

template< class PhysicalQuantityType >
class UnitaryLoadInstance: private AllowedUnitaryLoadType< PhysicalQuantityType >
{
    private:
        string    _name;
        PhysicalQuantityType::valueType

    public:
        UnitaryLoad(string name): _name( name )
        {}

        void setValue(ValueType valeur)
        {
            _value = valeur;
        }
}

typedef UnitaryLoadInstance< double > DoubleLoadInstance;

class LoadInstance

#endif /* UNITARYLOAD_H_ */
