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
#include "Results/ResultsContainer.h"


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
        /** @brief Instant/pas de chargement  défini par l'utilisateur */
        int _stepIndex;
        /** @brief Champ de déplacement */ 
        FieldOnNodesDoublePtr _depl;
        /** @brief Champ de contraintes */ 
        //FieldOnGaussPointsTensorPtr _sigm;
        /** @brief Champ de variables internes */
        // _vari
    public:
        /**
         * @brief Constructeur
         * @param step index (default value 0) 
         */
        StateInstance(int iStep = 0 ): _stepIndex(iStep)
        {};

        /**
         * @brief Destructeur
         */
        ~StateInstance()
        {};
        
        /**
        * @brief Define a displacement field as  state of an analysis
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
        * @brief Get the  displacement field 
        */
        FieldOnNodesDoublePtr getDisplacement() const
        {
            return _depl; 
        };
        /** @brief Initialiser un pas (temps/chargement) dans la sd résultat
            @param result data structure 
        */
        void setStep( ResultsContainerPtr result ) const 
        {
            if ( _depl )
            {
            //result-> setDisplacement ( _stepIndex, _depl); 
            }
            else
            {
            //TODO Initialiser à zéro mais c'est peut-être toujours le cas ??
            }
            // TODO on définit l'état  à partir de SIGM/VARI
        };
};


/**
 * @typedef StatePtr
 * @brief Pointeur intelligent vers un StateInstance
 */
typedef boost::shared_ptr< StateInstance > StatePtr;

#endif /* STATE_H_ */
