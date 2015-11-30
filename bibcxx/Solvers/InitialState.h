#ifndef INITIALSTATE_H_
#define INITIALSTATE_H_

/**
 * @file InitialState.h
 * @brief Fichier entete de la classe InitialState
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
#include "Results/ResultsContainer.h"


/**
 * @class InitialStateInstance
 * @brief Cette classe permet de definir l'état initial d'une analyse (par exemple d'une analyse non-linéaire) 
 * @author Natacha Béreux 
 */
class InitialStateInstance
{
    private:
        /** @brief Instant initial défini par l'utilisateur */
        int _stepIndex;
        /** @ brief Champ de déplacement à l'instant initial */ 
        FieldOnNodesDoublePtr _depl;
    public:
        /**
         * @brief Constructeur
         * @param 
         */
        InitialStateInstance(int iStep = 0 ): _stepIndex(iStep)
        {};

        /**
         * @brief Destructeur
         */
        ~InitialStateInstance()
        {};
        
        /**
        * @brief Define a displacement field as initial state of an analysis
        */
        void setDisplacement( FieldOnNodesDoublePtr depl ) 
        {
            _depl = depl; 
        };
        /** 
        */
        int getStepIndex() const 
        {
            return _stepIndex; 
        }
        /**
        * @brief Get the initial displacement field 
        */
        FieldOnNodesDoublePtr getDisplacement() const
        {
            return _depl; 
        };
        /** @brief Initialiser le premier pas de chargement dans la sd résultat 
        */
        void setInitialStep( ResultsContainerPtr result ) const 
        {
            if ( _depl )
            {
            //result-> setDisplacement ( _stepIndex, _depl); 
            }
            else
            {
            //TODO initialiser à zéro mais c'est peut-être toujours le cas ??
            }
            // TODO on définit l'état initial à partir de SIGM/VARI
        };
};


/**
 * @typedef InitialStatePtr
 * @brief Pointeur intelligent vers un InitialStateInstance
 */
typedef boost::shared_ptr< InitialStateInstance > InitialStatePtr;

#endif /* INITIALSTATE_H_ */
