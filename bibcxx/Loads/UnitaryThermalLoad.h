#ifndef UNITARYTHERMALLOAD_H_
#define UNITARYTHERMALLOAD_H_

/**
 * @file UnitaryThermalLoad.h
 * @brief Fichier entete de la classe UnitaryThermalLoad
 * @author Jean-Pierre Lefebvre
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

#include <stdexcept>
#include <list>
#include <string>
#include "astercxx.h"
#include "Utilities/CapyConvertibleValue.h"

/**
 * @class UnitaryThermalLoadInstance
 * @brief Classe definissant une charge thermique (issue d'AFFE_CHAR_THER)
 * @author Jean-Pierre Lefebvre
 */
class UnitaryThermalLoadInstance: public DataStructure
{
private:

public:
    /**
     * @brief Constructeur
     */
    UnitaryThermalLoadInstance()
    {};
};
template <class ValueType>
class ImposedTemperatureInstance: public UnitaryThermalLoadInstance
{
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
     * @brief Constructeur
     */
    ImposedTemperatureInstance(ValueType val=100.) :
    _value(val)
    {
	    std::cout << "Constructeur ImposedTemperatureInstance "<< _value << std::endl;	
	};

    void addGroupOfNodes( const std::string& nameOfGroup )
    {
        _entity.push_back( GroupOfNodesPtr( new GroupOfNodes( nameOfGroup ) ) );
        _toCapyConverter.add( new CapyConvertibleValue< VectorOfMeshEntityPtr >
                                    ( false, "GROUP_NO", _entity , false ) );
    };
};
 
template <class ValueType>
class DistributedFlowInstance: public UnitaryThermalLoadInstance
{
private:
    /** @typedef Pointeur intelligent sur un VirtualMeshEntity */
    typedef boost::shared_ptr< GroupOfElements > GroupOfElementsPtr;
    typedef std::vector< GroupOfElementsPtr > VectorGroupOfElements;

    VectorOfMeshEntityPtr _entity;
    ValueType _fluxn, _fluxnInf, _fluxnSup;
    ValueType _fluxx, _fluxy, _fluxz;
    CapyConvertibleContainer _toCapyConverter;
            
public:
    /**
     * @brief Constructeur
     */
    DistributedFlowInstance(ValueType val=200.) :
    _fluxn(val)
    {
       _toCapyConverter.add( new CapyConvertibleValue< double >  (true, "FLUX_REP", _fluxn,  false ) );
 	    std::cout << "Constructeur DistributedFlowInstance "<< _fluxn << std::endl;
	}; 

    void addGroupOfElements( const std::string& nameOfGroup )
    {
        _entity.push_back( GroupOfElementsPtr( new GroupOfElements( nameOfGroup ) ) );
        _toCapyConverter.add( new CapyConvertibleValue< VectorOfMeshEntityPtr >
                                    ( false, "GROUP_MA", _entity , false ) );
    };

    void setNormalFlow( ValueType val=0.0 ) throw ( std::runtime_error )
    {
		_fluxn = val;
        _toCapyConverter.add( new CapyConvertibleValue< double >  (true, "FLUX_REP", _fluxn,  false ) );
    };

    void setLowerNormalFlow( ValueType val=0.0 ) throw ( std::runtime_error )
    {
		_fluxnInf = val;
        _toCapyConverter.add( new CapyConvertibleValue< double >  (true, "FLUN_INF", _fluxnInf,  false ) );
    };
  
    void setUpperNormalFlow( ValueType val=0.0 ) throw ( std::runtime_error )
    {
        _fluxnSup = val;
        _toCapyConverter.add( new CapyConvertibleValue< double >  (true, "FLUN_SUP", _fluxnSup,  false ) );
    };

    void setFlowXYZ( ValueType valx=0.0, ValueType valy=0.0, ValueType valz=0.0) throw ( std::runtime_error )
    {
        _fluxx = valx;
        _fluxy = valy;
        _fluxz = valz;
        std::cout << "FLUX_XYZ " << _fluxx << " " << _fluxy << " " << _fluxz << std::endl;
        _toCapyConverter.add( new CapyConvertibleValue< double >  (true, "FLUX_X", _fluxx,  false ) );
        _toCapyConverter.add( new CapyConvertibleValue< double >  (true, "FLUX_Y", _fluxy,  false ) );
        _toCapyConverter.add( new CapyConvertibleValue< double >  (true, "FLUX_Z", _fluxz,  false ) );
    };

};

template <class ValueType>
class NonLinearFlowInstance: public UnitaryThermalLoadInstance
{
private:
    /** @typedef Pointeur intelligent sur un VirtualMeshEntity */
    typedef boost::shared_ptr< GroupOfElements > GroupOfElementsPtr;
    typedef std::vector< GroupOfElementsPtr > VectorGroupOfElements;

    VectorOfMeshEntityPtr _entity;
    ValueType _fluxn;
    CapyConvertibleContainer _toCapyConverter;
            
public:
    /**
     * @brief Constructeur
     */
    NonLinearFlowInstance(ValueType val=200.) :
    _fluxn(val)
    {
	    std::cout << "Constructeur NonLinearFlowInstance " << _fluxn <<std::endl;
	}; 

    void addGroupOfElements( const std::string& nameOfGroup )
    {
        _entity.push_back( GroupOfElementsPtr( new GroupOfElements( nameOfGroup ) ) );
        _toCapyConverter.add( new CapyConvertibleValue< VectorOfMeshEntityPtr >
                                    ( false, "GROUP_MA", _entity , false ) );
    };

    void setFlow( ValueType val=0.0 ) throw ( std::runtime_error )
    {
        _fluxn = val;
        _toCapyConverter.add( new CapyConvertibleValue< double >  (true, "FLUX_NL", _fluxn,  false ) );
    };
};

template <class ValueType>
class ExchangeInstance: public UnitaryThermalLoadInstance
{
private:
    /** @typedef Pointeur intelligent sur un VirtualMeshEntity */
    typedef boost::shared_ptr< GroupOfElements > GroupOfElementsPtr;
    typedef std::vector< GroupOfElementsPtr > VectorGroupOfElements;

    VectorOfMeshEntityPtr _entity;
    ValueType _coef_h, _temp_ext, _coef_h_inf, _temp_ext_inf, _coef_h_sup, _temp_ext_sup;
    CapyConvertibleContainer _toCapyConverter;      
     
public:
    /**
     * @brief Constructeur
     */
    ExchangeInstance(ValueType val1=20.0 , ValueType val2= 15.0) :
    _coef_h(val1),
    _temp_ext(val2) 
    {
	    std::cout << "Constructeur ExchangeInstance " << _coef_h <<std::endl;
	}; 
 
    void addGroupOfElements( const std::string& nameOfGroup )
    {
        _entity.push_back( GroupOfElementsPtr( new GroupOfElements( nameOfGroup ) ) );
        _toCapyConverter.add( new CapyConvertibleValue< VectorOfMeshEntityPtr >
                                    ( false, "GROUP_MA", _entity , false ) );
    };

    void setExchangeCoefficient ( ValueType val=0.0 ) throw ( std::runtime_error )
    {
        _coef_h = val;
        _toCapyConverter.add( new CapyConvertibleValue< double >  (false, "COEF_H", _coef_h,  false ) );
    };
 
    void setExternalTemperature ( ValueType val=0.0 ) throw ( std::runtime_error )
    {
        _temp_ext = val;
        _toCapyConverter.add( new CapyConvertibleValue< double >  (false, "TEMP_EXT", _temp_ext,  false ) );
    };

    void setExchangeCoefficientInfSup ( ValueType val1=0.0 , ValueType val2=0.0) throw ( std::runtime_error )
    {
        _coef_h_inf = val1;
        _toCapyConverter.add( new CapyConvertibleValue< double >  (false, "COEF_H_INF", _coef_h_inf,  false ) );
        _coef_h_sup = val2;
        _toCapyConverter.add( new CapyConvertibleValue< double >  (false, "COEF_H_SUP", _coef_h_sup,  false ) );
    };
    
    void setExternalTemperatureInfSup ( ValueType val1=0.0 , ValueType val2=0.0 ) throw ( std::runtime_error )
    {
        _temp_ext_inf = val1;
        _toCapyConverter.add( new CapyConvertibleValue< double >  (false, "TEMP_EXT_INF", _temp_ext_inf,  false ) );
        _temp_ext_sup = val2;
        _toCapyConverter.add( new CapyConvertibleValue< double >  (false, "TEMP_EXT_SUP", _temp_ext_inf,  false ) );
    };

};

template <class ValueType>
class ExchangeWallInstance: public UnitaryThermalLoadInstance
{
private:
    /** @typedef Pointeur intelligent sur un VirtualMeshEntity */
    typedef boost::shared_ptr< GroupOfElements > GroupOfElementsPtr;
    typedef std::vector< GroupOfElementsPtr > VectorGroupOfElements;

    VectorOfMeshEntityPtr _entity1 , _entity2 ;
    ValueType _coef_h;
    VectorDouble _tran;
    CapyConvertibleContainer _toCapyConverter;
            
public:
    /**
     * @brief Constructeur
     */
    ExchangeWallInstance(ValueType val=20.0 ) :
    _coef_h(val)
    {
	    std::cout << "Constructeur ExchangeWallInstance " << _coef_h <<std::endl; 
	}; 

    void setExchangeCoefficient ( ValueType val=0.0 ) throw ( std::runtime_error )
    {
        _coef_h = val;
        _toCapyConverter.add( new CapyConvertibleValue< double >  (true, "COEF_H", _coef_h,  false ) );
    };
 
    void setTranslation ( const VectorDouble& vec ) throw ( std::runtime_error )
    {
        _tran = vec;
        _toCapyConverter.add( new CapyConvertibleValue< VectorDouble >  (false, "TRAN", _tran,  false ) ); 
    };
 
    void addGroupOfElements( const std::string& nameOfGroup )
    {
        _entity1.push_back( GroupOfElementsPtr( new GroupOfElements( nameOfGroup ) ) );
        _toCapyConverter.add( new CapyConvertibleValue< VectorOfMeshEntityPtr >
                                    ( false, "GROUP_MA_1", _entity1 , false ) );
         _entity2.push_back( GroupOfElementsPtr( new GroupOfElements( nameOfGroup ) ) );
        _toCapyConverter.add( new CapyConvertibleValue< VectorOfMeshEntityPtr >
                                    ( false, "GROUP_MA_2", _entity2 , false ) );
   }; 
};

template <class ValueType>
class SourceInstance: public UnitaryThermalLoadInstance
{
private:
    /** @typedef Pointeur intelligent sur un VirtualMeshEntity */
    typedef boost::shared_ptr< GroupOfElements > GroupOfElementsPtr;
    typedef std::vector< GroupOfElementsPtr > VectorGroupOfElements;

    VectorOfMeshEntityPtr _entity;
    ValueType _source;
    CapyConvertibleContainer _toCapyConverter;
            
public:
    /**
     * @brief Constructeur
     */
    SourceInstance(ValueType val=0.0 ) :
    _source(val)
    {
	    std::cout << "Constructeur SourceInstance " << _source <<std::endl;
	}; 

    void setSource ( ValueType val=0.0 ) throw ( std::runtime_error )
    {
        _source = val;
        _toCapyConverter.add( new CapyConvertibleValue< double >  (true, "SOUR", _source,  false ) );    
    };
 
    void addGroupOfElements( const std::string& nameOfGroup )
    {
        _entity.push_back( GroupOfElementsPtr( new GroupOfElements( nameOfGroup ) ) );
        _toCapyConverter.add( new CapyConvertibleValue< VectorOfMeshEntityPtr >
                                    ( false, "GROUP_MA", _entity , false ) );
    };
};

template <class ValueType>
class NonLinearSourceInstance: public UnitaryThermalLoadInstance
{
private:
    /** @typedef Pointeur intelligent sur un VirtualMeshEntity */
    typedef boost::shared_ptr< GroupOfElements > GroupOfElementsPtr;
    typedef std::vector< GroupOfElementsPtr > VectorGroupOfElements;

    VectorOfMeshEntityPtr _entity;
    ValueType _source;
    CapyConvertibleContainer _toCapyConverter;
            
public:
    /**
     * @brief Constructeur
     */
    NonLinearSourceInstance(ValueType val=0.0 ) :
    _source(val)
    {
	    std::cout << "Constructeur NonLinearSourceInstance " << _source <<std::endl;
	}; 

    void setSource ( ValueType val=0.0 ) throw ( std::runtime_error )
    {
        _source = val;
        _toCapyConverter.add( new CapyConvertibleValue< double >  (true, "SOUR", _source,  false ) );    
    };
 
    void addGroupOfElements( const std::string& nameOfGroup )
    {
        _entity.push_back( GroupOfElementsPtr( new GroupOfElements( nameOfGroup ) ) );
        _toCapyConverter.add( new CapyConvertibleValue< VectorOfMeshEntityPtr >
                                    ( false, "GROUP_MA", _entity , false ) );
    };
};

template <class ValueType>
class ThermalRadiationInstance: public UnitaryThermalLoadInstance
{
private:
    /** @typedef Pointeur intelligent sur un VirtualMeshEntity */
    typedef boost::shared_ptr< GroupOfElements > GroupOfElementsPtr;
    typedef std::vector< GroupOfElementsPtr > VectorGroupOfElements;

    VectorOfMeshEntityPtr _entity;
    ValueType _sigma, _epsilon, _temp_ext;
    CapyConvertibleContainer _toCapyConverter;
            
public:
    /**
     * @brief Constructeur
     */
    ThermalRadiationInstance(ValueType val1=20.0 , ValueType val2= 1.0, ValueType val3= 15.0):
    _sigma(val1),
    _epsilon(val2),
    _temp_ext(val3) 
    {
	    std::cout << "Constructeur ThermalRadiation" << _sigma << "  " << _epsilon << "  " << _temp_ext <<std::endl;
	}; 

    void setExternalTemperature ( ValueType val=20.0 ) throw ( std::runtime_error )
    {
        _temp_ext = val;
        _toCapyConverter.add( new CapyConvertibleValue< double >  (true, "TEMP_EXT", _temp_ext,  false ) );
    };
  
    void setEpsilon ( ValueType val=0.0 ) throw ( std::runtime_error )
    {
        _epsilon = val;
        _toCapyConverter.add( new CapyConvertibleValue< double >  (true, "EPSILON", _epsilon,  false ) );
    };
    
    void setSigma ( ValueType val=5.67e-8 ) throw ( std::runtime_error )
    {
        _sigma = val;
        _toCapyConverter.add( new CapyConvertibleValue< double >  (true, "SIGMA", _sigma,  false ) );    
    };
    
    void addGroupOfElements( const std::string& nameOfGroup )
    {
        std::cout << "Charge ThermalRadiation" << std::endl;
        _entity.push_back( GroupOfElementsPtr( new GroupOfElements( nameOfGroup ) ) ); 
        _toCapyConverter.add( new CapyConvertibleValue< VectorOfMeshEntityPtr >
                                    ( false, "GROUP_MA", _entity , false ) );
    };
};
template <class ValueType>
class ThermalGradientInstance: public UnitaryThermalLoadInstance
{
private:
    /** @typedef Pointeur intelligent sur un VirtualMeshEntity */
    typedef boost::shared_ptr< GroupOfElements > GroupOfElementsPtr;
    typedef std::vector< GroupOfElementsPtr > VectorGroupOfElements;

    VectorOfMeshEntityPtr _entity;
    ValueType _fluxx, _fluxy, _fluxz;
    CapyConvertibleContainer _toCapyConverter;
            
public:
    /**
     * @brief Constructeur
     */
    ThermalGradientInstance(ValueType val1=0.0 , ValueType val2=0.0, ValueType val3=0.0):
    _fluxx(val1),
    _fluxy(val2),
    _fluxz(val3) 
    {
	    std::cout << "Constructeur ThermalGradient " << _fluxx << " " << _fluxy << " " << _fluxz << " " <<std::endl;
	}; 

    void setFlowXYZ( ValueType valx=0.0, ValueType valy=0.0, ValueType valz=0.0) throw ( std::runtime_error )
    {
        _fluxx = valx;
        _fluxy = valy;
        _fluxz = valz;
        std::cout << "FLUX_XYZ " << _fluxx << " " << _fluxy << " " << _fluxz << std::endl;
    };
    
    void addGroupOfElements( const std::string& nameOfGroup )
    {
        std::cout << "Charge ThermalGradient" << std::endl;
        _entity.push_back( GroupOfElementsPtr( new GroupOfElements( nameOfGroup ) ) );
    };
};

/**
 * @typedef UnitaryThermalLoad
 * @brief Pointeur intelligent vers un UnitaryThermalLoadInstance
 */
template class ImposedTemperatureInstance< double >;
typedef ImposedTemperatureInstance< double > DoubleImposedTemperatureInstance;
typedef boost::shared_ptr< DoubleImposedTemperatureInstance > DoubleImposedTemperaturePtr;

template class DistributedFlowInstance< double >;
typedef DistributedFlowInstance< double > DoubleDistributedFlowInstance;
typedef boost::shared_ptr< DoubleDistributedFlowInstance > DoubleDistributedFlowPtr;

template class NonLinearFlowInstance< double >;
typedef NonLinearFlowInstance< double > DoubleNonLinearFlowInstance;
typedef boost::shared_ptr< DoubleNonLinearFlowInstance > DoubleNonLinearFlowPtr;

template class ExchangeInstance< double >;
typedef ExchangeInstance< double > DoubleExchangeInstance;
typedef boost::shared_ptr< DoubleExchangeInstance > DoubleExchangePtr;

template class ExchangeWallInstance< double >;
typedef ExchangeWallInstance< double > DoubleExchangeWallInstance;
typedef boost::shared_ptr< DoubleExchangeWallInstance > DoubleExchangeWallPtr;

template class ThermalRadiationInstance< double >;
typedef ThermalRadiationInstance< double > DoubleThermalRadiationInstance;
typedef boost::shared_ptr< DoubleThermalRadiationInstance > DoubleThermalRadiationPtr;

template class ThermalGradientInstance< double >;
typedef ThermalGradientInstance< double > DoubleThermalGradientInstance;
typedef boost::shared_ptr< DoubleThermalGradientInstance > DoubleThermalGradientPtr;

typedef boost::shared_ptr< UnitaryThermalLoadInstance > UnitaryThermalLoadPtr;
/** @typedef std::list de UnitaryThermalLoad */
typedef std::list< UnitaryThermalLoadPtr > ListThermalLoad;
/** @typedef Iterateur sur une std::list de UnitaryThermalLoad */
typedef ListThermalLoad::iterator ListThermalLoadIter;
/** @typedef Iterateur constant sur une std::list de UnitaryThermalLoad */
typedef ListThermalLoad::const_iterator ListThermalLoadCIter;

#endif /* UNITARYTHERMALLOAD_H_ */
