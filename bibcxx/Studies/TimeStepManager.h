#ifndef TIMESTEPMANAGER_H_
#define TIMESTEPMANAGER_H_

/**
 * @file TimeStepManager.h
 * @brief Fichier entete de la classe TimeStepManager
 * @author Nicolas Sellenet
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "astercxx.h"

#include "MemoryManager/JeveuxVector.h"
#include "DataStructure/DataStructure.h"
#include "Studies/FailureConvergenceManager.h"
#include "Utilities/GenericParameter.h"
#include "Results/ResultsContainer.h"

/**
 * @class TimeStepManagerInstance
 * @brief Cette classe permet de definir un gestionnaire de pas de temps
 * @author Nicolas Sellenet
 * @todo ajouter les mots cles manquants
 */
class TimeStepManagerInstance: public DataStructure
{
private:
    /** @brief Liste d'instants */
    JeveuxVectorDouble _timeList;
    /** @brief Liste d'informations portant sur la liste d'instants */
    JeveuxVectorDouble _infoList;

    /** @brief Liste de double pour la gestion des échecs */
    JeveuxVectorDouble _doubleFailureManagerInfo;
    /** @brief Liste de chaine pour la gestion des échecs */
    JeveuxVectorChar16 _charFailureManagerInfo;
    /** @brief Liste de double pour la gestion des échecs */
    JeveuxVectorDouble _doubleFailureManagerInfo2;

    /** @brief Liste de pas de temps donnée par l'utilisateur */
    VectorDouble       _timeListVector;
    /** @brief Gestion automatique du pas de temps */
    bool               _isAutomatic;
    /** @brief Liste de comportement en cas d'erreurs */
    ListConvError      _listErrorManager;
    bool               _isEmpty;
    /** @brief Pas de temps mini */
    GenParam           _minimumTS;
    /** @brief Pas de temps maxi */
    GenParam           _maximumTS;
    /** @brief Nombre maxi de pas de temps */
    GenParam           _nbMaxiOfTS;

public:
    /**
     * @brief Constructeur
     */
    TimeStepManagerInstance():
        DataStructure( getNewResultObjectName(), "LIST_INST" ),
        _timeList( JeveuxVectorDouble( getName() + ".LIST.DITR" ) ),
        _infoList( JeveuxVectorDouble( getName() + ".LIST.INFOR" ) ),
        _doubleFailureManagerInfo( JeveuxVectorDouble( getName() + ".ECHE.EVENR" ) ),
        _charFailureManagerInfo( JeveuxVectorChar16( getName() + ".ECHE.INFOK" ) ),
        _doubleFailureManagerInfo2( JeveuxVectorDouble( getName() + ".ECHE.SUBDR" ) ),
        _isAutomatic( false ),
        _isEmpty( true ),
        _minimumTS( "PAS_MINI", false ),
        _maximumTS( "PAS_MAXI", false ),
        _nbMaxiOfTS( "NB_PAS_MAXI", 1000000, false )
    {};

    ~TimeStepManagerInstance()
    {};

    /**
     * @brief Fonction permettant d'ajouter un gestionnaire d'erreur
     * @param currentError erreur à ajouter
     */
    void addErrorManager( const GenericConvergenceErrorPtr& currentError ) throw ( std::runtime_error )
    {
        if ( ! currentError->isActionSet() )
            throw std::runtime_error( "Action on error not set" );
        _listErrorManager.push_back( currentError );
    };

    /**
     * @brief Construction de la sd_list_inst
     */
    void build() throw ( std::runtime_error );

    /**
     * @brief Fonction permettant de preciser le mode de gestion de la liste d'instants
     * @param isAuto true si la gestion est automatique
     */
    void setAutomaticManagement( const bool& isAuto ) throw ( std::runtime_error )
    {
        _isAutomatic = isAuto;
        if ( _isAutomatic ) throw std::runtime_error( "Not yet implemented" );
    };

    /**
     * @brief Function de définition du nombre maxi de pas
     * @param max nombre maxi de pas
     */
    void setMaximumNumberOfTimeStep( const int& max )
    {
         _nbMaxiOfTS = max;
    };

    /**
     * @brief Function de définition du pas de temps maxi
     * @param max pas de temps maxi
     */
    void setMaximumTimeStep( const double& max )
    {
        _maximumTS = max;
    };

    /**
     * @brief Function de définition du pas de temps mini
     * @param min pas de temps mini
     */
    void setMinimumTimeStep( const double& min )
    {
        _minimumTS = min;
    };

    /**
     * @brief Function de définition de la liste d'instants
     * @param timeList liste d'instants
     */
    void setTimeList( const VectorDouble& timeList )
    {
        _timeListVector = timeList;
    };

    /**
     * @brief Function de définition de la liste d'instants à partir d'un résu
     */
    void setTimeListFromResultsContainer() throw ( std::runtime_error )
    {
        throw std::runtime_error( "Not yet implemented" );
    };
};


/**
 * @typedef TimeStepManagerPtr
 * @brief Pointeur intelligent vers un TimeStepManager
 */
typedef boost::shared_ptr< TimeStepManagerInstance > TimeStepManagerPtr;

#endif /* TIMESTEPMANAGER_H_ */
