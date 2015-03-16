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
#include "DataFields/FieldOnNodes.h"

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

        /**
         * @brief Obtenir un champ au noeud réel à partir de son nom et de son numéro d'ordre
         * @param name nom Aster du champ
         * @param rank numéro d'ordre
         * @return FieldOnNodesDoublePtr pointant vers le champ
         */
        FieldOnNodesDoublePtr getRealFieldOnNodes( const std::string name, const int rank ) const;

        /**
         * @brief Impression de la sd au format MED
         * @param fileName Nom du fichier MED à imprimer
         * @return true
         * @todo revoir la gestion des mot-clés par défaut (ex : TOUT_ORDRE)
         * @todo revoir la gestion des unités logiques (notamment si fort.20 existe déjà)
         */
        bool printMedFile( std::string fileName ) const throw ( std::runtime_error );
};

/**
 * @typedef ResultsContainerPtr
 * @brief Pointeur intelligent vers un ResultsContainerInstance
 */
typedef boost::shared_ptr< ResultsContainerInstance > ResultsContainerPtr;

#endif /* RESULTSCONTAINER_H_ */
