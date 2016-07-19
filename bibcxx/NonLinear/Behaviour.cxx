/**
 * @file Behaviour.cxx
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

#include "Utilities/SyntaxDictionary.h"

#include <stdexcept>
#include <typeinfo>
#include "astercxx.h"

#include "NonLinear/Behaviour.h"

BehaviourInstance::BehaviourInstance( ConstitutiveLawEnum law, StrainEnum strain ): 
		_constitutiveLaw( law ), 
                _strain( strain )
        {

         _toCapyConverter.add( new CapyConvertibleValue< ConstitutiveLawEnum> 
                                                      ( true, "RELATION", _constitutiveLaw, allConstitutiveLaw, 
                                                      allConstitutiveLawNames , true ) ); 
 
         _toCapyConverter.add( new CapyConvertibleValue< StrainEnum> 
                                                      ( true, "DEFORMATION", _strain, allStrain, 
                                                      allStrainNames , true ) ); 

          _toCapyConverter.add( new CapyConvertibleValue< VectorOfLaw > 
                                                      ( false, "RELATION_KIT", _laws, allConstitutiveLaw, 
                                                       allConstitutiveLawNames , false ) );  
         
          _toCapyConverter.add( new CapyConvertibleValue< double >
                                                      ( false, "RESI_CPLAN_MAXI", _planeStressMaximumResidual, false) );
   
         _planeStressRelativeResidual =1.E-06; 
         _toCapyConverter.add( new CapyConvertibleValue< double >
                                                      ( false, "RESI_CPLAN_RELA", _planeStressRelativeResidual, true ) );

         _planeStressMaximumIteration = 1;
         _toCapyConverter.add( new CapyConvertibleValue< int >
                                                      ( false, "ITER_CPLAN_MAXI", _planeStressMaximumIteration, true ) );
        
         _theta = 1.0; 
         _toCapyConverter.add( new CapyConvertibleValue< double >
                                                      ( false, "PARM_THETA", _theta, true ) );
         _alpha = 1.0; 
 	 _toCapyConverter.add( new CapyConvertibleValue< double >
                                                      ( false, "PARM_ALPHA", _alpha, true ) );
         
         _toCapyConverter.add( new CapyConvertibleValue< double >
                                                      ( false, "RESI_INTE_MAXI", _integrationMaximumResidual, false ) );
 
         _toCapyConverter.add( new CapyConvertibleValue< double >
                                                      ( false, "RESI_INTE_RELA", _integrationRelativeResidual, false ) );
         
         _toCapyConverter.add( new CapyConvertibleValue< int >
                                                      ( false, "ITER_INTE_MAXI", _integrationMaximumIteration, false ) );

                                              
         if ( law != Mfront )
         {
             _integrationRelativeResidual = 1.E-06; 
             _toCapyConverter[  "RESI_INTE_RELA" ] -> enable(); 
             _toCapyConverter[  "RESI_INTE_MAXI" ] -> disable(); 
             _integrationMaximumIteration = 20; 
             _toCapyConverter[  "ITER_INTE_MAXI" ] -> enable(); 
         }
         else
         {
             _integrationMaximumResidual = 1.E-08; 
             _toCapyConverter[  "RESI_INTE_MAXI" ] -> enable();
             _toCapyConverter[  "RESI_INTE_RELA" ] -> disable();  
             _integrationMaximumIteration = 100; 
             _toCapyConverter[  "ITER_INTE_MAXI" ] -> enable(); 
         }

         _integrationIterationStep=0; 
         _toCapyConverter.add( new CapyConvertibleValue< int >
                                                      ( false, "ITER_INTE_PAS", _integrationIterationStep, true ) );

         _toCapyConverter.add( new CapyConvertibleValue< IntegrationAlgoEnum> 
                                                      ( false, "ALGO_INTE", _integrationAlgo, allIntegrationAlgo, 
                                                       allIntegrationAlgoNames , false ) ); 


         _toCapyConverter.add( new CapyConvertibleValue< TangentMatrixEnum> 
                                                      ( false, "TYP_MATR_TANG", _tangentMatrix, allTangentMatrix, 
                                                       allTangentMatrixNames , false ) ); 

         _toCapyConverter.add( new CapyConvertibleValue< double >
                                                      ( false, "RESI_RADI_RELA", _radialRelativeResidual, false ) );
   
         _toCapyConverter.add( new CapyConvertibleValue< double >
                                                      ( false, "SEUIL", _threshold, false ) );
         _toCapyConverter.add( new CapyConvertibleValue< double >
                                                      ( false, "AMPLITUDE", _amplitude, false ) );
         _toCapyConverter.add( new CapyConvertibleValue< double >
                                                      ( false, "TAUX_RETOUR", _returnRate, false ) );
         _toCapyConverter.add( new CapyConvertibleValue< double >
                                                      ( false, "VALE_PERT_RELA", _relativeLossValue, false ) );

        };
  
