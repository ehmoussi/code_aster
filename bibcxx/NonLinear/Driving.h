#ifndef DRIVING_H_
#define DRIVING_H_

/**
 * @file DRIVING.h
 * @brief Header file for Driving  Class
 * @author Natacha Béreux 
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
#include "Geometry/Geometry.h" 
#include "Loads/PhysicalQuantity.h"
#include "Modeling/XfemCrack.h"
#include "Utilities/CapyConvertibleValue.h"


/**
 * @enum DrivingTypeEnum
 * @brief All driving methods available 
 * @author Natacha Béreux 
 */
enum DrivingTypeEnum { DisplacementValue, DisplacementNorm, JumpOnCrackValue, 
    JumpOnCrackNorm, LimitLoad, MonotonicStrain,  ElasticityLimit};
extern const std::vector< DrivingTypeEnum > allDrivingType;
extern const std::vector< std::string > allDrivingTypeNames;

/**
 * Components defining the degree of freedom on which we act 
*/
extern const std::vector< PhysicalQuantityComponent > allDisplacementComponent;
extern const std::vector< std::string > allDisplacementComponentNames;


/**
 * @enum SelectionCriterionEnum
 * @brief Selection method used if several solutions are built 
 * by the driving 
 * @author Natacha Béreux
*/
enum SelectionCriterionEnum { SmallestDisplacementIncrement, SmallestAngleIncrement, SmallestResidual, MixedCriterion };
extern const std::vector<SelectionCriterionEnum> allSelectionCriterion;
extern const std::vector< std::string > allSelectionCriterionNames; 

/** 
 * @class DrivingInstance 
 * @brief defines a driving method and its parameters.
 * @author Natacha Béreux 
 */
class DrivingInstance
{
private:
    /** @brief Pointeur intelligent vers un VirtualMeshEntity */
    typedef boost::shared_ptr< VirtualMeshEntity > MeshEntityPtr;
    DrivingTypeEnum _type; 
    double                    _coefMult;
    MeshEntityPtr             _zone;
    XfemCrackPtr              _crack;
    PhysicalQuantityComponent _component; 
    UnitVectorEnum            _direction;
    double                    _etaMin;
    double                    _etaMax;
    double                    _etaRMin;
    double                    _etaRMax;
    bool                      _keepInRange; 
    SelectionCriterionEnum    _criterion;
    int                       _monotony;  
    
    CapyConvertibleContainer _toCapyConverter;
    
public:
    DrivingInstance( DrivingTypeEnum type ): 
        _type( type ),
        _coefMult( 1.0 ),
        _keepInRange(true), 
        _criterion( SmallestDisplacementIncrement ), 
        _monotony(0) 
    {  
       _toCapyConverter.add( new CapyConvertibleValue< DrivingTypeEnum> 
                               ( true, "TYPE", _type, allDrivingType, 
                                 allDrivingTypeNames , true ) );

       std::string zoneTypeName("");
       if (( type == DisplacementValue ) ||  ( type == DisplacementNorm ) || 
           ( type == JumpOnCrackValue ) ||  ( type == JumpOnCrackNorm ) )
        // La zone pilotée est un ensemble de noeuds
             zoneTypeName = "GROUP_NO";
       if (( type == MonotonicStrain ) || ( type == ElasticityLimit ))
        // La zone pilotée est un ensemble de mailles 
       {
            zoneTypeName = "GROUP_MA";
       // valeur par défaut 
            _zone = MeshEntityPtr( new AllMeshEntities()); 
       }
    
       _toCapyConverter.add( new CapyConvertibleValue< MeshEntityPtr >
                                                      ( false, zoneTypeName, _zone, false ) );
       _toCapyConverter.add( new CapyConvertibleValue< double >
                                                      ( false, "COEF_MULT", _coefMult, true ) );
       _toCapyConverter.add( new CapyConvertibleValue< DataStructurePtr >
                                                      ( false, "FISSURE", (DataStructurePtr&)_crack, false ) );
       _toCapyConverter.add( new CapyConvertibleValue< PhysicalQuantityComponent> 
                                                      ( false, "NON_CMP", _component, allDisplacementComponent, 
                                                      allDisplacementComponentNames , false ) );
       _toCapyConverter.add( new CapyConvertibleValue< double >
                                                      ( false, "ETA_PILO_MIN", _etaMin, false ) );
       _toCapyConverter.add( new CapyConvertibleValue< double >
                                                      ( false, "ETA_PILO_MAX", _etaMax, false ) );
       _toCapyConverter.add( new CapyConvertibleValue< double >
                                                      ( false, "ETA_PILO_R_MIN", _etaRMin, false ) );
       _toCapyConverter.add( new CapyConvertibleValue< double >
                                                      ( false, "ETA_PILO_R_MAX", _etaRMax, false ) );
       _toCapyConverter.add( new CapyConvertibleValue< bool >
                                                      ( false, "PROJ_BORNES", _keepInRange,
                                                      { true, false }, { "OUI", "NON" }, true ) );
       _toCapyConverter.add( new CapyConvertibleValue< SelectionCriterionEnum> 
                                                      ( false, "SELECTION", _criterion, allSelectionCriterion, 
                                                      allSelectionCriterionNames , true ) );
       _toCapyConverter.add( new CapyConvertibleValue< UnitVectorEnum> 
                                                      ( false, "DIRE_PILO", _direction, allUnitVector, 
                                                      allUnitVectorNames , false ) );
       _toCapyConverter.add( new CapyConvertibleValue< int, std::string >
                                    ( false, "EVOL_PARA", _monotony,
                                      {0, 1,2}, {"SANS", "DECROISSANT","CROISSANT"}, true ) );
    }; 
   /**
   @brief addObservationGroupOfNodes
   */    
    void addObservationGroupOfNodes( const std::string& name ) throw ( std::runtime_error )
    {
       if (( _type == MonotonicStrain ) || ( _type == ElasticityLimit ))
           throw std::runtime_error( "Group of Nodes are not allowed with this type of driving" );
        _zone = MeshEntityPtr( new GroupOfNodes( name ) );
        _toCapyConverter[ "GROUP_NO" ]->enable();
       // et on n'a pas le droit de définir un group_ma 
        _toCapyConverter[ "GROUP_MA" ]->disable();
    };
    /** 
     * @brief Restriction de la zone de pilotage à une groupe de mailles 
     * par défaut la zone de pilotage inclut tout le modèle
     */
    void addObservationGroupOfElements( const std::string& name ) throw ( std::runtime_error )
    {
       if (( _type == DisplacementValue ) ||  ( _type == DisplacementNorm ) || 
            ( _type == JumpOnCrackValue ) ||  ( _type == JumpOnCrackNorm ) )
           throw std::runtime_error( "Group of Elements are not allowed with this type of driving" );
        _zone = MeshEntityPtr( new GroupOfElements( name ) );
        _toCapyConverter[ "GROUP_MA" ]->enable();
       // et on n'a pas le droit de définir un group_no
        _toCapyConverter[ "GROUP_NO" ]->disable();
    };
    /**
     * @brief définition d'une direction de pilotage sur une fissure XFEM
    */
    void setDrivingDirectionOnCrack( UnitVectorEnum dir ) throw ( std::runtime_error )
    {
      if (( _type == DisplacementValue ) ||  ( _type == DisplacementNorm ) || 
	  (_type == MonotonicStrain ))
	  throw std::runtime_error( "Defining a driving direction is only allowed for XFEM modeling" ); 
      _direction = dir; 
      _toCapyConverter[ "DIRE_PILO" ]->enable(); 
    }
    /** @brief fixe la valeur supérieure autorisée pour le paramètre de pilotage 
     *  nécessairement inférieure à etaRMax
     */
    void setMaximumValueOfDrivingParameter( double eta_max )
    {
      _etaMax = eta_max; 
      _toCapyConverter[ "ETA_PILO_MAX"]->enable(); 
    };
    /**  @brief fixe la valeur inférieure autorisée pour le  paramètre de pilotage
     *  nécessairement supérieure à etaRMin
     */
    void setMinimumValueOfDrivingParameter( double eta_min )
    {
      _etaMin = eta_min;
      _toCapyConverter[ "ETA_PILO_MIN"]->enable(); 
    };
    /**  @brief fixe la borne inférieure de l'intervalle de recherche pour le paramètre de pilotage
     */
    void setLowerBoundOfDrivingParameter( double etaRMin )
    {
      _etaRMin = etaRMin; 
      _toCapyConverter[ "ETA_PILO_R_MIN"]->enable(); 
    };
    /** @brief fixe la borne supérieure de l'intervalle de recherche pour le  paramètre de pilotage
     */
    void setUpperBoundOfDrivingParameter( double etaRMax )
    {
      _etaRMax = etaRMax; 
      _toCapyConverter[ "ETA_PILO_R_MAX"]->enable(); 
    };
    /** @brief si le paramètre de pilotage sort de la zone [etamin, etamax], on le remplace
     * par etamin ou etamax.
     */
    void activateThreshold()
    {
      _keepInRange = true;
      _toCapyConverter[ "PROJ_BORNES"]->enable(); 
    };
    /** @brief on autorise le paramètre de pilotage à sortir de l'intervalle [etamin, etamax]
     */
    void deactivateThreshold()
    {
      _keepInRange = false;
      _toCapyConverter[ "PROJ_BORNES"]->enable(); 
    };
    /** 
    */
    void setMultiplicativeCoefficient( double coeff ) 
    {
      _coefMult = coeff;
      _toCapyConverter[ "COEF_MULT" ]->enable(); 
    };
    /**
     */
    const CapyConvertibleContainer& getCapyConvertibleContainer() const
    {
        return _toCapyConverter;
    };
};



typedef boost::shared_ptr< DrivingInstance > DrivingPtr;

#endif /* DRIVING_H_ */
