#ifndef RESULTSCONTAINER_H_
#define RESULTSCONTAINER_H_

/**
 * @file ResultsContainer.h
 * @brief Fichier entete de la classe ResultsContainer
 * @author Nicolas Sellenet
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "astercxx.h"

#include "DataStructure/DataStructure.h"
#include "MemoryManager/JeveuxVector.h"
#include "MemoryManager/JeveuxCollection.h"
#include "MemoryManager/JeveuxBidirectionalMap.h"

/**
 * @class ResultsContainerInstance
 * @brief Cette classe correspond a la sd_resultat de Code_Aster, elle stocke des champs
 * @author Nicolas Sellenet
 */
class ResultsContainerInstance: public DataStructure
{
    private:
        /** @brief Pointeur de nom Jeveux '.DESC' */
        JeveuxBidirectionalMap _symbolicNamesOfFields;
        /** @brief Collection '.TACH' */
        JeveuxCollectionChar24 _namesOfFields;
        /** @brief Pointeur de nom Jeveux '.NOVA' */
        JeveuxBidirectionalMap _accessVariables;
        /** @brief Collection '.TAVA' */
        JeveuxCollectionChar8  _calculationParameter;
        /** @brief Vecteur Jeveux '.ORDR' */
        JeveuxVectorLong       _serialNumber;

    public:
        /**
         * @brief Constructeur
         */
        ResultsContainerInstance( const std::string resuTyp = "???" ):
                DataStructure( getNewResultObjectName(), resuTyp ),
                _symbolicNamesOfFields( JeveuxBidirectionalMap( getName() + "           .DESC" ) ),
                _namesOfFields( JeveuxCollectionChar24( getName() + "           .TACH" ) ),
                _accessVariables( JeveuxBidirectionalMap( getName() + "           .NOVA" ) ),
                _calculationParameter( JeveuxCollectionChar8( getName() + "           .TAVA" ) ),
                _serialNumber( JeveuxVectorLong( getName() + "           .ORDR" ) )
        {};
};

/**
 * @typedef ResultsContainerPtr
 * @brief Pointeur intelligent vers un ResultsContainerInstance
 */
typedef boost::shared_ptr< ResultsContainerInstance > ResultsContainerPtr;

#endif /* RESULTSCONTAINER_H_ */
