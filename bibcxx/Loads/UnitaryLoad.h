#ifndef UNITARYLOAD_H_
#define UNITARYLOAD_H_

#include "Loads/PhysicalQuantity.h"

/**
* class UnitaryLoad
*   Classe template definissant une paire d'un MeshEntity et d'une valeur imposee sur une composante
* @author Nicolas Sellenet
*/
template< class PhysicalQuantityType >
class UnitaryLoad
{
    private:
        typedef boost::shared_ptr< VirtualMeshEntity > MeshEntityPtr;

        typedef typename PhysicalQuantityType::QuantityType ValueType;

        // MeshEntity sur laquelle repose le "blocage"
        MeshEntityPtr        _supportMeshEntity;
        // "Numero" de la composante à imposer
        AsterCoordinates     _loadCoordinate;
        // Valeur a imposer
        ValueType            _value;
        // Grandeur sur laquelle repose
//         const PhysicalQuantityType _physicalQuantity;

    public:

        UnitaryLoad( MeshEntityPtr supportMeshEntity, AsterCoordinates curCoord, ValueType value ):
            _supportMeshEntity( supportMeshEntity ),
            _loadCoordinate( curCoord ),
            _value( value )
//             _physicalQuantity( PhysicalQuantityType() )
        {
            if ( ! PhysicalQuantityType::hasCoordinate( curCoord ) )
                throw string( AsterCoordinatesNames[ (int) curCoord ] ) + " not allowed";
        };

        const string getAsterCoordinateName() const
        {
            return string( AsterCoordinatesNames[ (int) _loadCoordinate ] );
        };

        const MeshEntityPtr& getMeshEntityPtr() const
        {
            return _supportMeshEntity;
        };

        const ValueType getValue() const
        {
            return _value;
        };
};

typedef UnitaryLoad< DoubleDisplacementType > DoubleLoadDisplacement;
typedef UnitaryLoad< DoubleTemperatureType > DoubleLoadTemperature;

#endif /* UNITARYLOAD_H_ */
