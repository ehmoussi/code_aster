#ifndef BEHAVIOUR_H_
#define BEHAVIOUR_H_

/**
 * @file Behaviour.h
 * @brief Definition of the (nonlinear) behaviour
 * @author Natacha Béreux
 * @section LICENCE
 *   Copyright (C) 1991 - 2014  EDF R&D                www.code-aster.org
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

/* person_in_charge: natacha.bereux at edf.fr */
#include "astercxx.h"

#include "LinearAlgebra/SolverControl.h"
#include "Materials/MaterialOnMesh.h"
#include "Mesh/MeshEntities.h"
#include "NonLinear/AllowedBehaviour.h"
#include "Modeling/Model.h"
#include "RunManager/CommandSyntaxCython.h"
#include "Utilities/GenericParameter.h"


class BehaviourInstance
{
private:
        typedef std::vector< ConstitutiveLawEnum > VectorOfLaw;
        /** @brief ConstitutiveLaw*/
        ConstitutiveLawEnum _constitutiveLaw;
        /** @brief Strain  */
        StrainEnum _strain;
        /** @brief RelationKit */
        VectorOfLaw _laws; 
        /** @brief  PlaneStress Residual Checking parameters*/
        double _planeStressMaximumResidual;
        double _planeStressRelativeResidual;
        int _planeStressMaximumIteration;
        double _theta;
        double _alpha; 
        /** @brief Integration Checking parameters */
        double _integrationMaximumResidual;
        double _integrationRelativeResidual;
        int    _integrationMaximumIteration;
        int    _integrationIterationStep;
        IntegrationAlgoEnum _integrationAlgo;
        // SolverControlPtr _control;
        /** @brief Matrix used during the iterative process*/
        TangentMatrixEnum _tangentMatrix;
        
        double _radialRelativeResidual; 
        double _threshold; 
        double _amplitude; 
        double _returnRate; 
        double _relativeLossValue; 
 
        CapyConvertibleContainer _toCapyConverter;
public:
        /**
         * @brief Constructeur
         */
        BehaviourInstance( ConstitutiveLawEnum law = Elas, StrainEnum strain = SmallStrain ); 
          
        /**
         * @brief Choose a type of tangent matrix 
        */
        void setTangentMatrix(  TangentMatrixEnum matrix )
        {
            _tangentMatrix =  matrix; 
            _toCapyConverter[ "TYP_MATR_TANG" ]->enable();
            if ( matrix == TangentSecantMatrix ) 
            {
                _threshold= 3.0;
                _toCapyConverter[ "SEUIL" ]->enable(); 
                _amplitude = 1.5;
                _toCapyConverter[ "AMPLITUDE" ]->enable(); 
                _returnRate =0.05;
                _toCapyConverter[ "TAUX_RETOUR" ]->enable();  
	    };
        };
        /** @brief Set theta parameter */
        void setTheta( double theta ) throw ( std::runtime_error )
        {
            if ( ( theta >= 0.0 ) && ( theta <= 1.0 ) )
	    {
                 _theta = theta; 
                 _toCapyConverter[ "PARM_THETA" ] ->enable(); 
            }
            else
 		throw std::runtime_error( "0 <= theta <= 1" ); 
        };
        /** @brief  Set alpha parameter */
        void setAlpha( double alpha )
        {
	    _alpha = alpha;
            _toCapyConverter[ "PARM_ALPHA" ] ->enable(); 
        };
        /** @brief define a radial relative residual */
        void setRadialRelativeResidual ( double radialRelativeResidual )
        {
            _radialRelativeResidual = radialRelativeResidual; 
            _toCapyConverter[ "RESI_RADI_RELA" ]->enable(); 
            _toCapyConverter[ "TYP_MATR_TANG" ] ->disable(); 
        };
        /** @brief Kit_ddi modele de comportement pour le béton 
                   combinant fluage et comportement elastoplastique ou endommageant.
            @todo verifier que les lois sont compatibles  
        */
        
        void setPlasticityCreepConstitutiveLaw( ConstitutiveLawEnum law1, ConstitutiveLawEnum law2 ) 
        {
	    _constitutiveLaw = Kit_Ddi;
           
            _laws.push_back( law1 );  
            _laws.push_back( law2 ); 
            _toCapyConverter.add( new CapyConvertibleValue< VectorOfLaw >
                                    ( true, "RELATION_KIT", _laws, true ) );
        };
      /**@brief Plane Stress Management Parameters */
      void setPlaneStressMaximumResidual( double planeStressMaximumResidual ) 
      {
          _planeStressMaximumResidual = planeStressMaximumResidual; 
          _toCapyConverter[ "RESI_CPLAN_MAXI" ]-> enable(); 
          _toCapyConverter[ "RESI_CPLAN_RELA" ]-> disable();
      };
      void setPlaneStressRelativeResidual( double planeStressRelativeResidual ) 
      {
          _planeStressRelativeResidual = planeStressRelativeResidual; 
          _toCapyConverter[ "RESI_CPLAN_MAXI" ]-> disable(); 
          _toCapyConverter[ "RESI_CPLAN_RELA" ]-> enable();
      };
      void setPlaneStressMaximumIteration( int maxIter ) 
      {
          _planeStressMaximumIteration = maxIter; 
          _toCapyConverter[ "ITER_CPLAN_MAXI" ]-> enable(); 
      };
      /**
      */
     const CapyConvertibleContainer& getCapyConvertibleContainer() const
     {
        return _toCapyConverter;
     };
};

/**
 * @typedef BehaviourPtr
 * @brief Enveloppe d'un pointeur intelligent vers un BehaviourInstance
 */
typedef boost::shared_ptr< BehaviourInstance > BehaviourPtr;

/** @typedef Smart pointer on a  VirtualMeshEntity */
typedef boost::shared_ptr< VirtualMeshEntity > MeshEntityPtr;
 

/** @typedef LocatedBehaviour is a Behaviour located on a MeshEntity */
class LocatedBehaviourInstance 
{
private:
    BehaviourPtr _behaviour;
    MeshEntityPtr _entity; 
    CapyConvertibleContainer _toCapyConverter;
    
public: 
    
    LocatedBehaviourInstance( BehaviourPtr behaviour, MeshEntityPtr entity ) :
        _behaviour( behaviour ), _entity( entity )
    {
         std::string entityName; 
         if (_entity->getType() == AllMeshEntitiesType )
         { 
             entityName = "TOUT"; 
         }
         else if ( _entity->getType() == GroupOfElementsType ) 
         { 
             entityName = "GROUP_MA"; 
         } 
         _toCapyConverter.add( new CapyConvertibleValue< MeshEntityPtr >
                                          ( true, entityName, _entity, true ) );
         _toCapyConverter+=_behaviour->getCapyConvertibleContainer();
    };
   /**
    */
    const CapyConvertibleContainer& getCapyConvertibleContainer() const
    {
        return _toCapyConverter;
    };
};

typedef boost::shared_ptr< LocatedBehaviourInstance> LocatedBehaviourPtr;

#endif /* BEHAVIOUR_H_ */
