#ifndef UNITARYTHERMALLOAD_H_
#define UNITARYTHERMALLOAD_H_

/**
 * @file UnitaryThermalLoad.h
 * @brief Fichier entete de la classe UnitaryThermalLoad
 * @author Jean-Pierre Lefebvre
 * @section LICENCE
 *   Copyright (C) 1991 - 2020  EDF R&D                www.code-aster.org
 *
 *   This file is part of Code_Aster.
 *
 *   Code_Aster is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
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

#include <stdexcept>
#include <list>
#include <string>
#include "astercxx.h"
#include "Utilities/CapyConvertibleValue.h"

/**
 * @class UnitaryThermalLoadClass
 * @brief Classe definissant une charge thermique (issue d'AFFE_CHAR_THER)
 * @author Jean-Pierre Lefebvre
 */
class UnitaryThermalLoadClass : public DataStructure {
  private:
  public:
    /**
     * @typedef UnitaryThermalLoadPtr
     * @brief Pointeur intelligent vers un UnitaryThermalLoad
     */
    typedef boost::shared_ptr< UnitaryThermalLoadClass > UnitaryThermalLoadPtr;

    /**
     * @brief Constructeur
     */
    UnitaryThermalLoadClass() : DataStructure( "", Permanent, 8 ){};
};

template < class ValueType > class ImposedTemperatureClass : public UnitaryThermalLoadClass {
  private:
    /** @typedef Pointeur intelligent sur un VirtualMeshEntity */
    typedef boost::shared_ptr< GroupOfNodes > GroupOfNodesPtr;
    typedef std::vector< GroupOfNodesPtr > VectorGroupOfNodes;

    VectorOfMeshEntityPtr _entity;
    ValueType _value;
    /**
     * @brief Conteneur des mots-clé
     */
    CapyConvertibleContainer _toCapyConverter;

  public:
    /**
     * @typedef ImposedTemperaturePtr
     * @brief Pointeur intelligent vers un ImposedTemperature
     */
    typedef boost::shared_ptr< ImposedTemperatureClass > ImposedTemperaturePtr;

    /**
     * @brief Constructeur
     */
    ImposedTemperatureClass( ValueType val = 100. ) : _value( val ){};

    void addGroupOfNodes( const std::string &nameOfGroup ) {
        _entity.push_back( GroupOfNodesPtr( new GroupOfNodes( nameOfGroup ) ) );
        _toCapyConverter.add( new CapyConvertibleValue< VectorOfMeshEntityPtr >( false, "GROUP_NO",
                                                                                 _entity, false ) );
    };
};

template < class ValueType > class DistributedFlowClass : public UnitaryThermalLoadClass {
  private:
    /** @typedef Pointeur intelligent sur un VirtualMeshEntity */
    typedef boost::shared_ptr< GroupOfCells > GroupOfCellsPtr;
    typedef std::vector< GroupOfCellsPtr > VectorGroupOfCells;

    VectorOfMeshEntityPtr _entity;
    ValueType _fluxn, _fluxnInf, _fluxnSup;
    ValueType _fluxx, _fluxy, _fluxz;
    CapyConvertibleContainer _toCapyConverter;

  public:
    /**
     * @typedef DistributedFlowPtr
     * @brief Pointeur intelligent vers un DistributedFlow
     */
    typedef boost::shared_ptr< DistributedFlowClass > DistributedFlowPtr;

    /**
     * @brief Constructeur
     */
    DistributedFlowClass( ValueType val = 200. ) : _fluxn( val ) {
        _toCapyConverter.add(
            new CapyConvertibleValue< double >( true, "FLUX_REP", _fluxn, false ) );
    };

    void addGroupOfCells( const std::string &nameOfGroup ) {
        _entity.push_back( GroupOfCellsPtr( new GroupOfCells( nameOfGroup ) ) );
        _toCapyConverter.add( new CapyConvertibleValue< VectorOfMeshEntityPtr >( false, "GROUP_MA",
                                                                                 _entity, false ) );
    };

    void setNormalFlow( ValueType val = 0.0 ) {
        _fluxn = val;
        _toCapyConverter.add(
            new CapyConvertibleValue< double >( true, "FLUX_REP", _fluxn, false ) );
    };

    void setLowerNormalFlow( ValueType val = 0.0 ) {
        _fluxnInf = val;
        _toCapyConverter.add(
            new CapyConvertibleValue< double >( true, "FLUN_INF", _fluxnInf, false ) );
    };

    void setUpperNormalFlow( ValueType val = 0.0 ) {
        _fluxnSup = val;
        _toCapyConverter.add(
            new CapyConvertibleValue< double >( true, "FLUN_SUP", _fluxnSup, false ) );
    };

    void setFlowXYZ( ValueType valx = 0.0, ValueType valy = 0.0,
                     ValueType valz = 0.0 ) {
        _fluxx = valx;
        _fluxy = valy;
        _fluxz = valz;
        _toCapyConverter.add( new CapyConvertibleValue< double >( true, "FLUX_X", _fluxx, false ) );
        _toCapyConverter.add( new CapyConvertibleValue< double >( true, "FLUX_Y", _fluxy, false ) );
        _toCapyConverter.add( new CapyConvertibleValue< double >( true, "FLUX_Z", _fluxz, false ) );
    };
};

template < class ValueType > class NonLinearFlowClass : public UnitaryThermalLoadClass {
  private:
    /** @typedef Pointeur intelligent sur un VirtualMeshEntity */
    typedef boost::shared_ptr< GroupOfCells > GroupOfCellsPtr;
    typedef std::vector< GroupOfCellsPtr > VectorGroupOfCells;

    VectorOfMeshEntityPtr _entity;
    ValueType _fluxn;
    CapyConvertibleContainer _toCapyConverter;

  public:
    /**
     * @typedef NonLinearFlowPtr
     * @brief Pointeur intelligent vers un NonLinearFlow
     */
    typedef boost::shared_ptr< NonLinearFlowClass > NonLinearFlowPtr;

    /**
     * @brief Constructeur
     */
    NonLinearFlowClass( ValueType val = 200. ) : _fluxn( val ){};

    void addGroupOfCells( const std::string &nameOfGroup ) {
        _entity.push_back( GroupOfCellsPtr( new GroupOfCells( nameOfGroup ) ) );
        _toCapyConverter.add( new CapyConvertibleValue< VectorOfMeshEntityPtr >( false, "GROUP_MA",
                                                                                 _entity, false ) );
    };

    void setFlow( ValueType val = 0.0 ) {
        _fluxn = val;
        _toCapyConverter.add(
            new CapyConvertibleValue< double >( true, "FLUX_NL", _fluxn, false ) );
    };
};

template < class ValueType > class ExchangeClass : public UnitaryThermalLoadClass {
  private:
    /** @typedef Pointeur intelligent sur un VirtualMeshEntity */
    typedef boost::shared_ptr< GroupOfCells > GroupOfCellsPtr;
    typedef std::vector< GroupOfCellsPtr > VectorGroupOfCells;

    VectorOfMeshEntityPtr _entity;
    ValueType _coef_h, _temp_ext, _coef_h_inf, _temp_ext_inf, _coef_h_sup, _temp_ext_sup;
    CapyConvertibleContainer _toCapyConverter;

  public:
    /**
     * @typedef ExchangePtr
     * @brief Pointeur intelligent vers un Exchange
     */
    typedef boost::shared_ptr< ExchangeClass > ExchangePtr;

    /**
     * @brief Constructeur
     */
    ExchangeClass( ValueType val1 = 20.0, ValueType val2 = 15.0 )
        : _coef_h( val1 ), _temp_ext( val2 ){};

    void addGroupOfCells( const std::string &nameOfGroup ) {
        _entity.push_back( GroupOfCellsPtr( new GroupOfCells( nameOfGroup ) ) );
        _toCapyConverter.add( new CapyConvertibleValue< VectorOfMeshEntityPtr >( false, "GROUP_MA",
                                                                                 _entity, false ) );
    };

    void setExchangeCoefficient( ValueType val = 0.0 ) {
        _coef_h = val;
        _toCapyConverter.add(
            new CapyConvertibleValue< double >( false, "COEF_H", _coef_h, false ) );
    };

    void setExternalTemperature( ValueType val = 0.0 ) {
        _temp_ext = val;
        _toCapyConverter.add(
            new CapyConvertibleValue< double >( false, "TEMP_EXT", _temp_ext, false ) );
    };

    void setExchangeCoefficientInfSup( ValueType val1 = 0.0,
                                       ValueType val2 = 0.0 ) {
        _coef_h_inf = val1;
        _toCapyConverter.add(
            new CapyConvertibleValue< double >( false, "COEF_H_INF", _coef_h_inf, false ) );
        _coef_h_sup = val2;
        _toCapyConverter.add(
            new CapyConvertibleValue< double >( false, "COEF_H_SUP", _coef_h_sup, false ) );
    };

    void setExternalTemperatureInfSup( ValueType val1 = 0.0,
                                       ValueType val2 = 0.0 ) {
        _temp_ext_inf = val1;
        _toCapyConverter.add(
            new CapyConvertibleValue< double >( false, "TEMP_EXT_INF", _temp_ext_inf, false ) );
        _temp_ext_sup = val2;
        _toCapyConverter.add(
            new CapyConvertibleValue< double >( false, "TEMP_EXT_SUP", _temp_ext_inf, false ) );
    };
};

template < class ValueType > class ExchangeWallClass : public UnitaryThermalLoadClass {
  private:
    /** @typedef Pointeur intelligent sur un VirtualMeshEntity */
    typedef boost::shared_ptr< GroupOfCells > GroupOfCellsPtr;
    typedef std::vector< GroupOfCellsPtr > VectorGroupOfCells;

    VectorOfMeshEntityPtr _entity1, _entity2;
    ValueType _coef_h;
    VectorReal _tran;
    CapyConvertibleContainer _toCapyConverter;

  public:
    /**
     * @typedef ExchangeWallPtr
     * @brief Pointeur intelligent vers un ExchangeWall
     */
    typedef boost::shared_ptr< ExchangeWallClass > ExchangeWallPtr;

    /**
     * @brief Constructeur
     */
    ExchangeWallClass( ValueType val = 20.0 ) : _coef_h( val ){};

    void setExchangeCoefficient( ValueType val = 0.0 ) {
        _coef_h = val;
        _toCapyConverter.add(
            new CapyConvertibleValue< double >( true, "COEF_H", _coef_h, false ) );
    };

    void setTranslation( const VectorReal &vec ) {
        _tran = vec;
        _toCapyConverter.add(
            new CapyConvertibleValue< VectorReal >( false, "TRAN", _tran, false ) );
    };

    void addGroupOfCells( const std::string &nameOfGroup ) {
        _entity1.push_back( GroupOfCellsPtr( new GroupOfCells( nameOfGroup ) ) );
        _toCapyConverter.add( new CapyConvertibleValue< VectorOfMeshEntityPtr >(
            false, "GROUP_MA_1", _entity1, false ) );
        _entity2.push_back( GroupOfCellsPtr( new GroupOfCells( nameOfGroup ) ) );
        _toCapyConverter.add( new CapyConvertibleValue< VectorOfMeshEntityPtr >(
            false, "GROUP_MA_2", _entity2, false ) );
    };
};

template < class ValueType > class SourceClass : public UnitaryThermalLoadClass {
  private:
    /** @typedef Pointeur intelligent sur un VirtualMeshEntity */
    typedef boost::shared_ptr< GroupOfCells > GroupOfCellsPtr;
    typedef std::vector< GroupOfCellsPtr > VectorGroupOfCells;

    VectorOfMeshEntityPtr _entity;
    ValueType _source;
    CapyConvertibleContainer _toCapyConverter;

  public:
    /**
     * @typedef SourcePtr
     * @brief Pointeur intelligent vers un Source
     */
    typedef boost::shared_ptr< SourceClass > SourcePtr;

    /**
     * @brief Constructeur
     */
    SourceClass( ValueType val = 0.0 ) : _source( val ){};

    void setSource( ValueType val = 0.0 ) {
        _source = val;
        _toCapyConverter.add( new CapyConvertibleValue< double >( true, "SOUR", _source, false ) );
    };

    void addGroupOfCells( const std::string &nameOfGroup ) {
        _entity.push_back( GroupOfCellsPtr( new GroupOfCells( nameOfGroup ) ) );
        _toCapyConverter.add( new CapyConvertibleValue< VectorOfMeshEntityPtr >( false, "GROUP_MA",
                                                                                 _entity, false ) );
    };
};

template < class ValueType > class NonLinearSourceClass : public UnitaryThermalLoadClass {
  private:
    /** @typedef Pointeur intelligent sur un VirtualMeshEntity */
    typedef boost::shared_ptr< GroupOfCells > GroupOfCellsPtr;
    typedef std::vector< GroupOfCellsPtr > VectorGroupOfCells;

    VectorOfMeshEntityPtr _entity;
    ValueType _source;
    CapyConvertibleContainer _toCapyConverter;

  public:
    /**
     * @typedef NonLinearSourcePtr
     * @brief Pointeur intelligent vers un NonLinearSource
     */
    typedef boost::shared_ptr< NonLinearSourceClass > NonLinearSourcePtr;

    /**
     * @brief Constructeur
     */
    NonLinearSourceClass( ValueType val = 0.0 ) : _source( val ){};

    void setSource( ValueType val = 0.0 ) {
        _source = val;
        _toCapyConverter.add( new CapyConvertibleValue< double >( true, "SOUR", _source, false ) );
    };

    void addGroupOfCells( const std::string &nameOfGroup ) {
        _entity.push_back( GroupOfCellsPtr( new GroupOfCells( nameOfGroup ) ) );
        _toCapyConverter.add( new CapyConvertibleValue< VectorOfMeshEntityPtr >( false, "GROUP_MA",
                                                                                 _entity, false ) );
    };
};

template < class ValueType > class ThermalRadiationClass : public UnitaryThermalLoadClass {
  private:
    /** @typedef Pointeur intelligent sur un VirtualMeshEntity */
    typedef boost::shared_ptr< GroupOfCells > GroupOfCellsPtr;
    typedef std::vector< GroupOfCellsPtr > VectorGroupOfCells;

    VectorOfMeshEntityPtr _entity;
    ValueType _sigma, _epsilon, _temp_ext;
    CapyConvertibleContainer _toCapyConverter;

  public:
    /**
     * @typedef ThermalRadiationPtr
     * @brief Pointeur intelligent vers un ThermalRadiation
     */
    typedef boost::shared_ptr< ThermalRadiationClass > ThermalRadiationPtr;

    /**
     * @brief Constructeur
     */
    ThermalRadiationClass( ValueType val1 = 20.0, ValueType val2 = 1.0, ValueType val3 = 15.0 )
        : _sigma( val1 ), _epsilon( val2 ), _temp_ext( val3 ){};

    void setExternalTemperature( ValueType val = 20.0 ) {
        _temp_ext = val;
        _toCapyConverter.add(
            new CapyConvertibleValue< double >( true, "TEMP_EXT", _temp_ext, false ) );
    };

    void setEpsilon( ValueType val = 0.0 ) {
        _epsilon = val;
        _toCapyConverter.add(
            new CapyConvertibleValue< double >( true, "EPSILON", _epsilon, false ) );
    };

    void setSigma( ValueType val = 5.67e-8 ) {
        _sigma = val;
        _toCapyConverter.add( new CapyConvertibleValue< double >( true, "SIGMA", _sigma, false ) );
    };

    void addGroupOfCells( const std::string &nameOfGroup ) {
        _entity.push_back( GroupOfCellsPtr( new GroupOfCells( nameOfGroup ) ) );
        _toCapyConverter.add( new CapyConvertibleValue< VectorOfMeshEntityPtr >( false, "GROUP_MA",
                                                                                 _entity, false ) );
    };
};

template < class ValueType > class ThermalGradientClass : public UnitaryThermalLoadClass {
  private:
    /** @typedef Pointeur intelligent sur un VirtualMeshEntity */
    typedef boost::shared_ptr< GroupOfCells > GroupOfCellsPtr;
    typedef std::vector< GroupOfCellsPtr > VectorGroupOfCells;

    VectorOfMeshEntityPtr _entity;
    ValueType _fluxx, _fluxy, _fluxz;
    CapyConvertibleContainer _toCapyConverter;

  public:
    /**
     * @typedef ThermalGradientPtr
     * @brief Pointeur intelligent vers un ThermalGradient
     */
    typedef boost::shared_ptr< ThermalGradientClass > ThermalGradientPtr;

    /**
     * @brief Constructeur
     */
    ThermalGradientClass( ValueType val1 = 0.0, ValueType val2 = 0.0, ValueType val3 = 0.0 )
        : _fluxx( val1 ), _fluxy( val2 ), _fluxz( val3 ){};

    void setFlowXYZ( ValueType valx = 0.0, ValueType valy = 0.0,
                     ValueType valz = 0.0 ) {
        _fluxx = valx;
        _fluxy = valy;
        _fluxz = valz;
    };

    void addGroupOfCells( const std::string &nameOfGroup ) {
        _entity.push_back( GroupOfCellsPtr( new GroupOfCells( nameOfGroup ) ) );
    };
};

/**
 * @typedef UnitaryThermalLoad
 * @brief Pointeur intelligent vers un UnitaryThermalLoadClass
 */
template class ImposedTemperatureClass< double >;
typedef ImposedTemperatureClass< double > RealImposedTemperatureClass;
typedef boost::shared_ptr< RealImposedTemperatureClass > RealImposedTemperaturePtr;

template class DistributedFlowClass< double >;
typedef DistributedFlowClass< double > RealDistributedFlowClass;
typedef boost::shared_ptr< RealDistributedFlowClass > RealDistributedFlowPtr;

template class NonLinearFlowClass< double >;
typedef NonLinearFlowClass< double > RealNonLinearFlowClass;
typedef boost::shared_ptr< RealNonLinearFlowClass > RealNonLinearFlowPtr;

template class ExchangeClass< double >;
typedef ExchangeClass< double > RealExchangeClass;
typedef boost::shared_ptr< RealExchangeClass > RealExchangePtr;

template class ExchangeWallClass< double >;
typedef ExchangeWallClass< double > RealExchangeWallClass;
typedef boost::shared_ptr< RealExchangeWallClass > RealExchangeWallPtr;

template class SourceClass< double >;
typedef SourceClass< double > RealSourceClass;
typedef boost::shared_ptr< RealSourceClass > RealSourcePtr;

template class NonLinearSourceClass< double >;
typedef NonLinearSourceClass< double > RealNonLinearSourceClass;
typedef boost::shared_ptr< RealNonLinearSourceClass > RealNonLinearSourcePtr;

template class ThermalRadiationClass< double >;
typedef ThermalRadiationClass< double > RealThermalRadiationClass;
typedef boost::shared_ptr< RealThermalRadiationClass > RealThermalRadiationPtr;

template class ThermalGradientClass< double >;
typedef ThermalGradientClass< double > RealThermalGradientClass;
typedef boost::shared_ptr< RealThermalGradientClass > RealThermalGradientPtr;

typedef boost::shared_ptr< UnitaryThermalLoadClass > UnitaryThermalLoadPtr;
/** @typedef std::list de UnitaryThermalLoad */
typedef std::list< UnitaryThermalLoadPtr > ListThermalLoad;
/** @typedef Iterateur sur une std::list de UnitaryThermalLoad */
typedef ListThermalLoad::iterator ListThermalLoadIter;
/** @typedef Iterateur constant sur une std::list de UnitaryThermalLoad */
typedef ListThermalLoad::const_iterator ListThermalLoadCIter;

#endif /* UNITARYTHERMALLOAD_H_ */
