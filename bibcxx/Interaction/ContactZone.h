#ifndef CONTACTZONE_H_
#define CONTACTZONE_H_

/**
 * @file ContactZone.h
 * @brief Fichier entete de la class ContactZone
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2016  EDF R&D                www.code-aster.org
 *
 *   This file is part of Code_Aster.
 *
 *   Code_Aster is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 2 of the License, or
 *   (at your option) any later version.
 *
 *   Code_Aster is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "Mesh/Mesh.h"
#include "Function/Function.h"
#include "Utilities/CapyConvertibleValue.h"

/**
 * @enum NormTypeEnum
 * @brief Tous les types de contact disponibles
 * @author Nicolas Sellenet
 */
enum NormTypeEnum { MasterNorm, SlaveNorm, AverageNorm };
extern const std::vector< NormTypeEnum > allNormType;
extern const std::vector< std::string > allNormTypeNames;

/**
 * @enum PairingEnum
 * @brief Tous les types de contact disponibles
 * @author Nicolas Sellenet
 */
enum PairingEnum { NewtonPairing, FixPairing };
extern const std::vector< PairingEnum > allPairing;
extern const std::vector< std::string > allPairingNames;

class GenericContactZone
{
protected:
    CapyConvertibleContainer _toCapyConverter;

public:
    const CapyConvertibleContainer& getCapyConvertibleContainer() const
    {
        return _toCapyConverter;
    };
};

class ContactZoneInstance: public GenericContactZone
{
    /** @brief Pointeur intelligent vers un VirtualMeshEntity */
    typedef boost::shared_ptr< VirtualMeshEntity > MeshEntityPtr;
    typedef std::vector< MeshEntityPtr > VectorOfMeshEntityPtr;
    VectorOfMeshEntityPtr _master;
    VectorOfMeshEntityPtr _slave;
    NormTypeEnum          _normType;
    int                   _vectMait;
    VectorDouble          _masterVector;
    int                   _vectEscl;
    VectorDouble          _slaveVector;
    PairingEnum           _typeAppa;
    VectorDouble          _pairingVector;
    bool                  _beam;
    bool                  _plate;
    int                   _caraElem;
    FunctionPtr           _distMait;
    FunctionPtr           _distEscl;
    double                _pairingTolerance;
    double                _pairingMismatchProjectionTolerance;
    VectorOfMeshEntityPtr _elementsToExclude;
    VectorOfMeshEntityPtr _nodesToExclude;
    bool                  _solve;
    double                _interpenetrationTol;

public:
    ContactZoneInstance(): _normType( MasterNorm ),
                           _vectMait( 0 ),
                           _vectEscl( 0 ),
                           _typeAppa( NewtonPairing ),
                           _beam( false ),
                           _plate( false ),
                           _caraElem( 0 ),
                           _pairingTolerance( -1.0 ),
                           _pairingMismatchProjectionTolerance( 0.5 ),
                           _solve( true ),
                           _interpenetrationTol( 0. )
    {
        _toCapyConverter.add( new CapyConvertibleValue< VectorOfMeshEntityPtr >
                                    ( true, "GROUP_MA_MAIT", _master, true ) );
        _toCapyConverter.add( new CapyConvertibleValue< VectorOfMeshEntityPtr >
                                    ( true, "GROUP_MA_ESCL", _slave, true ) );

        _toCapyConverter.add( new CapyConvertibleValue< NormTypeEnum >
                                    ( false, "NORMALE", _normType,
                                      allNormType, allNormTypeNames, true ) );

        _toCapyConverter.add( new CapyConvertibleValue< int, std::string >
                                    ( false, "VECT_MAIT", _vectMait,
                                      {0, 1, 2}, {"AUTO", "FIXE", "VECT_Y"}, true ) );
        _toCapyConverter.add( new CapyConvertibleValue< VectorDouble >
                                    ( false, "MAIT_FIXE", _masterVector, false ) );
        _toCapyConverter.add( new CapyConvertibleValue< VectorDouble >
                                    ( false, "MAIT_VECT_Y", _masterVector, false ) );

        _toCapyConverter.add( new CapyConvertibleValue< int, std::string >
                                    ( false, "VECT_ESCL", _vectEscl,
                                      {0, 1,2}, {"AUTO", "FIXE","VECT_Y"}, true ) );
        _toCapyConverter.add( new CapyConvertibleValue< VectorDouble >
                                    ( false, "ESCL_FIXE", _slaveVector, false ) );
        _toCapyConverter.add( new CapyConvertibleValue< VectorDouble >
                                    ( false, "ESCL_VECT_Y", _slaveVector, false ) );

        _toCapyConverter.add( new CapyConvertibleValue< PairingEnum >
                                    ( false, "TYPE_APPA", _typeAppa, true ) );
        _toCapyConverter.add( new CapyConvertibleValue< VectorDouble >
                                    ( false, "DIRE_APPA", _pairingVector, false ) );

        _toCapyConverter.add( new CapyConvertibleValue< bool >
                                    ( false, "DIST_POUTRE", _beam,
                                      { true, false }, { "OUI", "NON" }, true ) );
        _toCapyConverter.add( new CapyConvertibleValue< bool >
                                    ( false, "DIST_COQUE", _plate,
                                      { true, false }, { "OUI", "NON" }, true ) );
        _toCapyConverter.add( new CapyConvertibleValue< int >
                                    ( false, "CARA_ELEM", _caraElem, false ) );

        _toCapyConverter.add( new CapyConvertibleValue< DataStructurePtr >
                                    ( false, "DIST_MAIT", (DataStructurePtr&)_distMait, false ) );
        _toCapyConverter.add( new CapyConvertibleValue< DataStructurePtr >
                                    ( false, "DIST_ESCL", (DataStructurePtr&)_distEscl, false ) );

        _toCapyConverter.add( new CapyConvertibleValue< double >
                                    ( false, "TOLE_APPA", _pairingTolerance, true ) );
        _toCapyConverter.add( new CapyConvertibleValue< double >
                                    ( false, "TOLE_PROJ_EXT", _pairingMismatchProjectionTolerance,
                                      true ) );

        _toCapyConverter.add( new CapyConvertibleValue< VectorOfMeshEntityPtr >
                                    ( false, "SANS_GROUP_MA", _elementsToExclude, false ) );
        _toCapyConverter.add( new CapyConvertibleValue< VectorOfMeshEntityPtr >
                                    ( false, "SANS_GROUP_NO", _nodesToExclude, false ) );

        _toCapyConverter.add( new CapyConvertibleValue< bool >
                                    ( false, "RESOLUTION", _solve,
                                      { true, false }, { "OUI", "NON" }, true ) );
        _toCapyConverter.add( new CapyConvertibleValue< double >
                                    ( false, "TOLE_INTERP", _interpenetrationTol,
                                      { true, false }, { "OUI", "NON" }, false ) );
    };

    void addBeamDescription() throw ( std::runtime_error )
    {
        _beam = true;
        _toCapyConverter[ "CARA_ELEM" ]->enable();
        _toCapyConverter[ "CARA_ELEM" ]->setMandatory( true );
        throw std::runtime_error( "Not yet implemented" );
    };

    void addPlateDescription() throw ( std::runtime_error )
    {
        _beam = true;
        throw std::runtime_error( "Not yet implemented" );
    };

    void addMasterGroupOfElements( const std::string& name )
    {
        _master.push_back( MeshEntityPtr( new GroupOfElements( name ) ) );
    };

    void addSlaveGroupOfElements( const std::string& name )
    {
        _slave.push_back( MeshEntityPtr( new GroupOfElements( name ) ) );
    };

    void disableResolution( const double tolInterp = 0. )
    {
        _solve = false;
        _interpenetrationTol = tolInterp;
        _toCapyConverter[ "TOLE_INTERP" ]->enable();
    };

    void excludeGroupOfElementsFromSlave( const std::string& name )
    {
        _toCapyConverter[ "SANS_GROUP_MA" ]->enable();
        _elementsToExclude.push_back( MeshEntityPtr( new GroupOfElements( name ) ) );
    };

    void excludeGroupOfNodesFromSlave( const std::string& name )
    {
        _toCapyConverter[ "SANS_GROUP_NO" ]->enable();
        _nodesToExclude.push_back( MeshEntityPtr( new GroupOfElements( name ) ) );
    };

    void setFixMasterVector( const VectorDouble& vec )
    {
        _masterVector = vec;
        _vectMait = 1;
        _toCapyConverter[ "MAIT_FIXE" ]->enable();
        _toCapyConverter[ "MAIT_VECT_Y" ]->disable();
    };

    void setMasterDistanceFunction( const FunctionPtr& func )
    {
        _distMait = func;
        _toCapyConverter[ "DIST_MAIT" ]->enable();
    };

    void setSlaveDistanceFunction( const FunctionPtr& func )
    {
        _distEscl = func;
        _toCapyConverter[ "DIST_ESCL" ]->enable();
    };

    void setPairingVector( const VectorDouble& vec )
    {
        _pairingVector = vec;
        _typeAppa = FixPairing;
        _toCapyConverter[ "DIRE_APPA" ]->enable();
    };

    void setTangentMasterVector( const VectorDouble& vec )
    {
        _masterVector = vec;
        _vectMait = 2;
        _toCapyConverter[ "MAIT_FIXE" ]->disable();
        _toCapyConverter[ "MAIT_VECT_Y" ]->enable();
    };

    void setNormType( const NormTypeEnum& normType )
    {
        _normType = normType;
    };
};

typedef boost::shared_ptr< ContactZoneInstance > ContactZonePtr;

#endif /* CONTACTZONE_H_ */
