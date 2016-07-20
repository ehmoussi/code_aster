#ifndef STATE_H_
#define STATE_H_

/**
 * @file State.h
 * @brief Fichier entete de la classe State
 * @author Natacha Béreux 
 * @section LICENCE
 *   Copyright (C) 1991 - 2015  EDF R&D                www.code-aster.org
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


#include "DataFields/FieldOnNodes.h"
#include "Results/NonLinearEvolutionContainer.h"


/**
 * @class StateInstance
 * @brief Cette classe permet de definir l'état d'une analyse (par exemple d'une analyse non-linéaire) 
 * L'algorithme (non-linéaire) permet de calculer l'état courant (i.e. la valeur des champs de déplacement, de contraintes, 
 * de variables internes) à partir de l'état précédent (valeur des mêmes champs au pas précédent)
 * @author Natacha Béreux 
 */
class StateInstance
{
    private:
        /** @brief current index  */
        int _currentIndex;
        /** @brief current step */
        double _currentStep; 
        /** @brief Champ de déplacement */ 
        FieldOnNodesDoublePtr _depl;
        /** @brief Champ de contraintes */ 
        //FieldOnGaussPointsTensorPtr _sigm;
        /** @brief Champ de variables internes */
        // _vari
        
        GenParam _evolParam;
        GenParam _sourceStepParam;
        GenParam _sourceIndexParam;
        GenParam _DirichletSourceIndexParam;
        GenParam _currentStepParam;
        GenParam _precisionParam; 
        
        ListGenParam _listOfParameters;
    public:
        /**
         * @brief Constructeur
         * @param step index (default value 0) 
         */
        StateInstance( int index = 0, double step = 0.0 ): 
          _currentIndex(index),
          _currentStep(step), 
          _evolParam("EVOL_NOLI", false),
          _sourceStepParam("INST", false),
          _sourceIndexParam("NUME_ORDRE", false), 
          _DirichletSourceIndexParam("NUME_DIDI", false), 
          _currentStepParam("INST_ETAT_INIT", false), 
          _precisionParam("PRECISION", false)
          
        {
            _listOfParameters.push_back( &_evolParam ); 
            _listOfParameters.push_back( &_sourceStepParam ); 
            _listOfParameters.push_back( &_sourceIndexParam ); 
            _listOfParameters.push_back( &_DirichletSourceIndexParam ); 
            _listOfParameters.push_back( &_currentStepParam ); 
            _listOfParameters.push_back( &_precisionParam ); 
        };
         
        /**
         * @brief Destructeur
         */
        ~StateInstance()
        {};

        /** @brief define the state from the result of a previous nonlinear anaysis
            @todo réaliser l'extraction des champs depuis l'evol_noli et associer les pointeurs _depl etc 
        */
        void setFromNonLinearEvolution( const NonLinearEvolutionContainerPtr&  evol_noli, 
                                        double sourceStep, double precision=1.E-06 )
        {
            std::cout << "setFromNonLinearEvolution" << std::endl; 
            //_evolParam =  evol_noli->getName();
            _sourceStepParam = sourceStep;
            _precisionParam = precision;
         // set default value of currentStepParam (INST_ETAT_INIT)
            //this-> setCurrentStep( sourceStep );
	};
        /** @brief define the state from the result of a previous nonlinear anaysis
        */

        void setFromNonLinearEvolution( const NonLinearEvolutionContainerPtr&  evol_noli, 
                                        int sourceIndex )
        {
            _evolParam =  evol_noli->getName();
            _sourceIndexParam = sourceIndex;
            // set default value of currentStepParam & currentStepParam(INST_ETAT_INIT)
            //this-> setCurrentStep( sourceIndex );
            _depl = evol_noli->getRealFieldOnNodes( "DEPL" , sourceIndex ); 
	};
        /**
        * L'état est défini à partir d'evol_noli. Si on ne précise ni instant (sourceStep)
        * ni numéro d'ordre (sourceIndex), l'état est initialisé à partir du dernier 
        * calcul effectué (de numéro d'ordre lastIndex dans la sd evol_noli) 
        */
        void setFromNonLinearEvolution( const NonLinearEvolutionContainerPtr&  evol_noli )
        {
            int lastIndex = evol_noli->getNumberOfRanks(); 
            setFromNonLinearEvolution( evol_noli, lastIndex ); 
	}
        /** @brief set the value of the current step 
        */ 
        void setCurrentStep ( double step )
        {
	        _currentStep = step; 
            _currentStepParam = step; 
        };

        /**
        * @brief Define a displacement field as  state of an analysis
        */
        void setDisplacement( FieldOnNodesDoublePtr depl )
        {
            _depl = depl; 
        };
        
        /** 
        * @brief get current step 
        */
        double getStep() const 
        {
            return _currentStep; 
        }
        /** 
        * @brief get current index 
        */
        int getIndex() const 
        {
            return _currentIndex; 
        }
        /**
        * @brief Get the  displacement field 
        */
        FieldOnNodesDoublePtr getDisplacement() const
        {
            return _depl; 
        };
        /**
         * @brief Récupération de la liste des paramètres 
         * @return Liste constante des paramètres déclarés
         */
        const ListGenParam& getListOfParameters() const
        {
            return _listOfParameters;
        };
};


/**
 * @typedef StatePtr
 * @brief Pointeur intelligent vers un StateInstance
 */
typedef boost::shared_ptr< StateInstance > StatePtr;

#endif /* STATE_H_ */
