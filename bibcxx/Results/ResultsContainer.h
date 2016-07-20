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
#include "DataFields/FieldOnElements.h"
#include "Discretization/DOFNumbering.h"

/**
 * @class ResultsContainerInstance
 * @brief Cette classe correspond a la sd_resultat de Code_Aster, elle stocke des champs
 * @author Nicolas Sellenet
 */
class ResultsContainerInstance: public DataStructure
{
private:
    typedef std::vector< FieldOnNodesDoublePtr > VectorOfFieldsNodes;
    typedef std::vector< FieldOnElementsDoublePtr > VectorOfFieldsElements;

    /** @typedef std::map d'une chaine et des pointers vers toutes les DataStructure */
    typedef std::map< std::string, VectorOfFieldsNodes > mapStrVOFN;
    /** @typedef Iterateur sur le std::map */
    typedef mapStrVOFN::iterator mapStrVOFNIterator;
    /** @typedef Valeur contenue dans mapStrVOFN */
    typedef mapStrVOFN::value_type mapStrVOFNValue;

    /** @typedef std::map d'une chaine et des pointers vers toutes les DataStructure */
    typedef std::map< std::string, VectorOfFieldsElements > mapStrVOFE;
    /** @typedef Iterateur sur le std::map */
    typedef mapStrVOFE::iterator mapStrVOFEIterator;
    /** @typedef Valeur contenue dans mapStrVOFE */
    typedef mapStrVOFE::value_type mapStrVOFEValue;

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
    /** @brief Nombre de numéros d'ordre */
    int                    _nbRanks;

    /** @brief Liste des champs aux noeuds */
    mapStrVOFN                           _dictOfVectorOfFieldsNodes;
    /** @brief Liste des champs aux éléments */
    mapStrVOFE                           _dictOfVectorOfFieldsElements;
    /** @brief Liste des NUME_DDL */
    std::vector< DOFNumberingPtr >       _listOfDOFNum;

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
            _serialNumber( JeveuxVectorLong( getName() + "           .ORDR" ) ),
            _nbRanks( 0 )
    {};

    /**
     * @brief Allouer une sd_resultat
     * @param nbRanks nombre de numéro d'ordre
     * @return true si l'allocation s'est bien passée
     */
    bool allocate( int nbRanks ) throw ( std::runtime_error );

    /**
     * @brief Construire une sd_resultat à partir d'objet produit dans le Fortran
     * @return true si l'allocation s'est bien passée
     * @todo revoir l'agrandissement de dictOfVectorOfFieldsNodes et dictOfVectorOfFieldsElements
     */
    bool buildFromExisting() throw ( std::runtime_error );

    /**
     * @brief Obtenir un DOFNumbering à remplir
     * @return DOFNumbering à remplir
     */
    DOFNumberingPtr getEmptyDOFNumbering();

    /**
     * @brief Obtenir un champ aux noeuds réel vide à partir de son nom et de son numéro d'ordre
     * @param name nom Aster du champ
     * @param rank numéro d'ordre
     * @return FieldOnNodesDoublePtr pointant vers le champ
     */
    FieldOnNodesDoublePtr getEmptyFieldOnNodesDouble( const std::string name, const int rank )
        throw ( std::runtime_error );

    /**
     * @brief Obtenir le dernier DOFNumbering
     * @return Dernier DOFNumbering
     */
    DOFNumberingPtr getLastDOFNumbering() const
    {
        return _listOfDOFNum[ _listOfDOFNum.size() - 1 ];
    };

    /**
     * @brief Obtenir un champ aux noeuds réel à partir de son nom et de son numéro d'ordre
     * @param name nom Aster du champ
     * @param rank numéro d'ordre
     * @return FieldOnElementsDoublePtr pointant vers le champ
     */
    FieldOnElementsDoublePtr getRealFieldOnElements( const std::string name, const int rank ) const
        throw ( std::runtime_error );

    /**
     * @brief Obtenir un champ aux noeuds réel à partir de son nom et de son numéro d'ordre
     * @param name nom Aster du champ
     * @param rank numéro d'ordre
     * @return FieldOnNodesDoublePtr pointant vers le champ
     */
    FieldOnNodesDoublePtr getRealFieldOnNodes( const std::string name, const int rank ) const
        throw ( std::runtime_error );

    /**
     * @brief Impression de la sd au format MED
     * @param fileName Nom du fichier MED à imprimer
     * @return true
     * @todo revoir la gestion des mot-clés par défaut (ex : TOUT_ORDRE)
     * @todo revoir la gestion des unités logiques (notamment si fort.20 existe déjà)
     */
    bool printMedFile( std::string fileName ) const throw ( std::runtime_error );

    /**
    * @brief Get the number of steps stored in the ResultContainer
    * @return nbRanks
    */
    const int getNumberOfRanks() const
    {
        return _nbRanks;
    }
};

/**
 * @typedef ResultsContainerPtr
 * @brief Pointeur intelligent vers un ResultsContainerInstance
 */
typedef boost::shared_ptr< ResultsContainerInstance > ResultsContainerPtr;

#endif /* RESULTSCONTAINER_H_ */
