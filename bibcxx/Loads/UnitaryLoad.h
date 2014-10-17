#ifndef UNITARYLOAD_H_
#define UNITARYLOAD_H_

template< class PhysicalQuantityType >
class UnitaryLoadInstance: private AllowedUnitaryLoadType< PhysicalQuantityType >
{
    private:
        typedef PhysicalQuantityType::valueType valueType;

        string     _name;
        MeshEntity _supportMeshEntity;

    public:
        UnitaryLoad( string name ): _name( name )
        {}

        void setValue(ValueType valeur)
        {
            _value = valeur;
        }
}

typedef UnitaryLoadInstance< DoubleDisplacement > DoubleLoadInstance;


#endif /* UNITARYLOAD_H_ */
