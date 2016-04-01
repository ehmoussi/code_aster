#ifndef FAILURECONVERGENCEMANAGER_H_
#define FAILURECONVERGENCEMANAGER_H_

/**
 * @file FailureConvergenceManager.h
 * @brief Fichier entete de la classe FailureConvergenceManager
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
#include "Utilities/GenericParameter.h"
#include "Loads/PhysicalQuantity.h"

/**
 * @enum ActionTypeEnum
 * @brief Types d'action pouvant être entreprises en cas d'erreur de convergence
 * @author Nicolas Sellenet
 */
enum ActionTypeEnum { StopOnErrorType, SubstepingOnErrorType,
                      SubstepingOnContactType, AddIterationOnErrorType, PilotageErrorType,
                      ChangePenalisationOnErrorType, ContinueOnErrorType, NoActionType };

const int nbActions = 8;
/**
 * @var ActionNames
 * @brief Nom au sens capy des actions
 */
extern const char* ActionNames[nbActions];

/**
 * @enum ConvergenceErrorTypeEnum
 * @brief Types d'action pouvant être détectées dans l'algo de STAT_NON_LINE
 * @author Nicolas Sellenet
 */
enum ConvergenceErrorTypeEnum { ConvergenceErrorType, ResidualDivergenceErrorType,
                                IncrementOverboundErrorType, ContactDetectionErrorType,
                                InterpenetrationErrorType, InstabilityErrorType, NoErrorType };

const int nbErrors = 7;
/**
 * @var ErrorNames
 * @brief Nom au sens capy des erreurs
 */
extern const char* ErrorNames[nbErrors];

/**
 * @class GenericActionInstance
 * @brief Cette classe définit une action générique en cas d'erreur détéctée
 * @author Nicolas Sellenet
 * @todo peut-être passer le type d'action en argument template
 */
class GenericActionInstance
{
private:
    /** @brief Nom (capy) de l'action */
    GenParam             _actionName;
    /** @brief Type de l'erreur */
    const ActionTypeEnum _type;

protected:
    /** @brief Liste des paramètres liés à l'action */
    ListGenParam         _listParam;

public:
    /**
     * @brief Constructeur
     * @param type Type de l'action
     */
    GenericActionInstance( ActionTypeEnum type ): _actionName( "ACTION",
                                                               std::string( ActionNames[ type ] ) ),
                                                  _type( type )
    {
        _listParam.push_back( &_actionName );
    };

    /**
     * @brief Constructeur par défaut (utile pour cython ?)
     */
    GenericActionInstance(): _actionName( "ACTION",
                                          std::string( ActionNames[ NoActionType ], true ) ),
                             _type( NoActionType )
    {};

    /**
     * @brief Récupération de la liste des paramètres de l'action
     * @return Liste constante des paramètres déclarés
     */
    const ListGenParam& getListOfParameters() const
    {
        return _listParam;
    };

    /**
     * @brief Récupération du type d'action
     * @return type ActionTypeEnum de l'action
     */
    const ActionTypeEnum& getType() const
    {
        return _type;
    };
};

/**
 * @class StopOnErrorInstance
 * @brief Classe correspondant à l'action "ARRET"
 * @author Nicolas Sellenet
 */
class StopOnErrorInstance: public GenericActionInstance
{
public:
    /** @brief Constructeur par défaut */
    StopOnErrorInstance(): GenericActionInstance( StopOnErrorType )
    {};
};

/**
 * @class ContinueOnErrorInstance
 * @brief Classe correspondant à l'action "CONTINUE"
 * @author Nicolas Sellenet
 */
class ContinueOnErrorInstance: public GenericActionInstance
{
public:
    /** @brief Constructeur par défaut */
    ContinueOnErrorInstance(): GenericActionInstance( ContinueOnErrorType )
    {};
};

/**
 * @class GenericSubstepingOnErrorInstance
 * @brief Classe correspondant à l'action générique "DECOUPE"
 * @author Nicolas Sellenet
 */
class GenericSubstepingOnErrorInstance: public GenericActionInstance
{
private:
    /** @brief Paramètre SUBD_METHODE */
    GenParam _isAuto;
    /** @brief Paramètre SUBD_PAS */
    GenParam _step;
    /** @brief Paramètre SUBD_NIVEAU */
    GenParam _level;
    /** @brief Paramètre SUBD_PAS_MINI */
    GenParam _minimumStep;

protected:
    /**
     * @brief Constructeur appelable depuis les classes filles
     * @param type ActionTypeEnum
     */
    GenericSubstepingOnErrorInstance( ActionTypeEnum type ):
        GenericActionInstance( type ),
        _isAuto( "SUBD_METHODE", std::string( "MANUEL" ) ),
        _step( "SUBD_PAS", 4 ),
        _level( "SUBD_NIVEAU", 3 ),
        _minimumStep( "SUBD_PAS_MINI", 0. )
    {
        _listParam.push_back( &_isAuto );
        _listParam.push_back( &_step );
        _listParam.push_back( &_level );
        _listParam.push_back( &_minimumStep );
    };

public:
    /** @brief Constructeur par défaut */
    GenericSubstepingOnErrorInstance(): GenericSubstepingOnErrorInstance( NoActionType )
    {};

    ~GenericSubstepingOnErrorInstance()
    {};

    /**
     * @brief Fixer la méthode de découpage du pas de temps
     * @param isAuto true si SUBD_METHODE = "AUTO"
     */
    void setAutomatic( const bool& isAuto )
    {
        if ( isAuto )
        {
            _isAuto = "AUTO";
            _step.setIsSet( false );
            _level.setIsSet( false );
        }
        else
        {
            _isAuto = "MANUEL";
            _step.setValueIfUnset( 4 );
            _level.setValueIfUnset( 3 );
        }
    };

    /**
     * @brief Fixer le niveau de sous-découpage
     * @param level niveau
     */
    void setLevel( const int& level )
    {
        _level = level;
    };

    /**
     * @brief Fixer le pas minimum
     * @param minimumStep valeur pour SUBD_PAS_MINI
     */
    void setMinimumStep( const double& minimumStep )
    {
        _minimumStep = minimumStep;
    };

    /**
     * @brief Fixer le nombre de découpage d'un pas de temps
     */
    void setStep( const int& step )
    {
        _step = step;
    };
};

/**
 * @class SubstepingOnErrorInstance
 * @brief Classe correspondant à l'action "DECOUPE"
 * @author Nicolas Sellenet
 */
class SubstepingOnErrorInstance: public GenericSubstepingOnErrorInstance
{
public:
    /** @brief Constructeur */
    SubstepingOnErrorInstance(): GenericSubstepingOnErrorInstance( SubstepingOnErrorType )
    {};
};

/**
 * @class AddIterationOnErrorInstance
 * @brief Classe correspondant à l'action générique "ITRE_SUPPL"
 * @author Nicolas Sellenet
 */
class AddIterationOnErrorInstance: public GenericSubstepingOnErrorInstance
{
private:
    /** @brief Paramètre PCENT_ITER_PLUS */
    GenParam _pcent;

public:
    AddIterationOnErrorInstance(): GenericSubstepingOnErrorInstance( AddIterationOnErrorType ),
                                   _pcent( "PCENT_ITER_PLUS", 50. )
    {
        _listParam.push_back( &_pcent );
    };

    ~AddIterationOnErrorInstance()
    {};

    /**
     * @brief Fixer PCENT_ITER_PLUS
     * @param pcent double précisant le pourcentage
     */
    void setPourcentageOfAddedIteration( const double& pcent )
    {
        _pcent = pcent;
    };
};

/**
 * @class SubstepingOnContactInstance
 * @brief Classe correspondant à l'action "DECOUPE" en situation de contact
 * @author Nicolas Sellenet
 */
class SubstepingOnContactInstance: public GenericActionInstance
{
private:
    /** @brief Paramètre SUBD_METHODE */
    GenParam _isAuto;
    /** @brief Paramètre SUBD_PAS */
    GenParam _step;
    /** @brief Paramètre SUBD_NIVEAU */
    GenParam _level;
    /** @brief Paramètre SUBD_PAS_MINI */
    GenParam _minimumStep;
    /** @brief Paramètre SUBD_INST */
    GenParam _timeStepSubstep;
    /** @brief Paramètre SUBD_DUREE */
    GenParam _substepDuration;

public:
    /** @brief Constructeur */
    SubstepingOnContactInstance(): GenericActionInstance( SubstepingOnContactType ),
                                   _isAuto( "SUBD_METHODE", std::string( "AUTO" ) ),
                                   _step( "SUBD_PAS" ),
                                   _level( "SUBD_NIVEAU" ),
                                   _minimumStep( "SUBD_PAS_MINI" ),
                                   _timeStepSubstep( "SUBD_INST", 0., true ),
                                   _substepDuration( "SUBD_DUREE", 0., true )
    {
        _listParam.push_back( &_isAuto );
        _listParam.push_back( &_step );
        _listParam.push_back( &_level );
        _listParam.push_back( &_minimumStep );
        _listParam.push_back( &_timeStepSubstep );
        _listParam.push_back( &_substepDuration );
    };

    ~SubstepingOnContactInstance()
    {};

    /**
     * @brief Fixer la méthode de découpage du pas de temps
     * @param isAuto true si SUBD_METHODE = "AUTO"
     */
    void setAutomatic( const bool& isAuto )
    {
        if ( isAuto )
        {
            _isAuto = "AUTO";

            _step.setIsSet( false );
            _level.setIsSet( false );
            _minimumStep.setIsSet( false );

            _timeStepSubstep.setMandatory( true );
            _substepDuration.setMandatory( true );
        }
        else
        {
            _isAuto = "MANUEL";

            _step.setValueIfUnset( 4 );
            _level.setValueIfUnset( 3 );
            _minimumStep.setValueIfUnset( 0. );

            _timeStepSubstep.setMandatory( false );
            _timeStepSubstep.setIsSet( false );
            _substepDuration.setMandatory( false );
            _substepDuration.setIsSet( false );
        }
    };

    /**
     * @brief Fixer la durée du sous-découage
     * @param duration double contenant la durée
     */
    void setSubstepDuration( const double& duration )
    {
        _substepDuration = duration;
    };

    /**
     * @brief Fixer l'instant du sous-découpage
     * @param time double contenant l'instant
     */
    void setTimeStepSubstep( const double& time )
    {
        _timeStepSubstep = time;
    };
};

/**
 * @class PilotageErrorInstance
 * @brief Classe correspondant à l'action "AUTRE_PILOTAGE"
 * @author Nicolas Sellenet
 */
class PilotageErrorInstance: public GenericSubstepingOnErrorInstance
{
public:
    /** @brief Constructeur */
    PilotageErrorInstance(): GenericSubstepingOnErrorInstance( PilotageErrorType )
    {};
};

/**
 * @class PilotageErrorInstance
 * @brief Classe correspondant à l'action "ADAPT_COEF_PENA"
 * @author Nicolas Sellenet
 */
class ChangePenalisationOnErrorInstance: public GenericActionInstance
{
private:
    GenParam _coefMax;

public:
    /** @brief Constructeur */
    ChangePenalisationOnErrorInstance(): GenericActionInstance( ChangePenalisationOnErrorType ),
                                         _coefMax( "COEF_MAXI", 1e12 )
    {
        _listParam.push_back( &_coefMax );
    };

    ~ChangePenalisationOnErrorInstance()
    {};

    /** @brief Fixer COEF_MAXI */
    void setMaximumPenalisationCoefficient( const double& coef )
    {
        _coefMax = coef;
    };
};

/** @typedef Pointeur intelligent vers un GenericActionInstance */
typedef boost::shared_ptr< GenericActionInstance > GenericActionPtr;

/** @typedef Pointeur intelligent vers un StopOnErrorInstance */
typedef boost::shared_ptr< StopOnErrorInstance > StopOnErrorPtr;
/** @typedef Pointeur intelligent vers un GenericSubstepingOnErrorInstance */
typedef boost::shared_ptr< GenericSubstepingOnErrorInstance > GenericSubstepingOnErrorPtr;
/** @typedef Pointeur intelligent vers un SubstepingOnErrorInstance */
typedef boost::shared_ptr< SubstepingOnErrorInstance > SubstepingOnErrorPtr;
/** @typedef Pointeur intelligent vers un SubstepingOnContactInstance */
typedef boost::shared_ptr< SubstepingOnContactInstance > SubstepingOnContactPtr;
/** @typedef Pointeur intelligent vers un AddIterationOnErrorInstance */
typedef boost::shared_ptr< AddIterationOnErrorInstance > AddIterationOnErrorPtr;
/** @typedef Pointeur intelligent vers un PilotageErrorInstance */
typedef boost::shared_ptr< PilotageErrorInstance > PilotageErrorPtr;
/** @typedef Pointeur intelligent vers un ChangePenalisationOnErrorInstance */
typedef boost::shared_ptr< ChangePenalisationOnErrorInstance > ChangePenalisationOnErrorPtr;
/** @typedef Pointeur intelligent vers un ContinueOnErrorInstance */
typedef boost::shared_ptr< ContinueOnErrorInstance > ContinueOnErrorPtr;


/**
 * @class GenericConvergenceErrorInstance
 * @brief Cette classe définit une erreur générique de convergence dont
 *        les autres doivent hériter
 * @author Nicolas Sellenet
 */
class GenericConvergenceErrorInstance
{
private:
    /** @brief Action à réaliser en cas d'erreur */
    GenericActionPtr _actionOnError;

protected:
    /** @brief Paramètre EVENEMENT */
    GenParam         _eventName;
    /** @brief Liste des Paramètres attachés à l'événement */
    ListGenParam     _listSyntaxParam;

    /**
     * @brief Constructeur
     * @param type ConvergenceErrorTypeEnum décrivant le type de l'erreur
     */
    GenericConvergenceErrorInstance( ConvergenceErrorTypeEnum type ): 
                _eventName( "EVENEMENT", std::string( ErrorNames[ type ] ), true )
    {
        _listSyntaxParam.push_back( &_eventName );
    };

public:
    /** @brief Constructeur par défaut */
    GenericConvergenceErrorInstance(): _eventName( "EVENEMENT", NoErrorType, true )
    {};

    ~GenericConvergenceErrorInstance()
    {};

private:
    /**
     * @brief Fonction virtuelle pure permettant de vérifier qu'une action est bien autorisée
     * @param action Action a tester
     */
    virtual void checkAllowedAction( const GenericActionPtr& action ) = 0;

public:
    /**
     * @brief Fonction permettant de récupérer l'action à réaliser en cas d'erreur
     * @return action à réaliser
     */
    const GenericActionPtr& getAction() const
    {
        return _actionOnError;
    };

    /**
     * @brief Fonction permettant de récupérer la liste des paramètres
     * @return liste des paramètres de l'événement
     */
    const ListGenParam& getListOfParameters() const
    {
        return _listSyntaxParam;
    };

    /**
     * @brief Fonction permettant de savoir si l'action en erreur a été définie
     * @return true si l'action a été fixée
     */
    bool isActionSet()
    {
        if ( ! _actionOnError ) return false;
        return true;
    };

    /**
     * @brief Fonction permettant de preciser l'action à réaliser en cas d'erreur
     * @param action action à réaliser
     */
    void setAction( const GenericActionPtr& action ) throw ( std::runtime_error )
    {
        _actionOnError = action;
        checkAllowedAction( action );
    };
};

/**
 * @class ConvergenceErrorInstance
 * @brief Classe décriant l'événement ERREUR
 * @author Nicolas Sellenet
 */
class ConvergenceErrorInstance: public GenericConvergenceErrorInstance
{
private:
    /**
     * @brief Fonction permettant de vérifier qu'une action est bien autorisée
     * @param action Action a tester
     */
    void checkAllowedAction( const GenericActionPtr& action ) throw ( std::runtime_error )
    {
        const ActionTypeEnum& type = action->getType();
        if ( type != StopOnErrorType && type != SubstepingOnErrorType &&\
             type != AddIterationOnErrorType && type != PilotageErrorType )
            throw std::runtime_error( "Action not allowed" );
    }

public:
    /** @brief Constructeur */
    ConvergenceErrorInstance(): GenericConvergenceErrorInstance( ConvergenceErrorType )
    {};

    ~ConvergenceErrorInstance()
    {};
};

/**
 * @class ResidualDivergenceErrorInstance
 * @brief Classe décriant l'événement DIVE_RESI
 * @author Nicolas Sellenet
 */
class ResidualDivergenceErrorInstance: public GenericConvergenceErrorInstance
{
private:
    /**
     * @brief Fonction permettant de vérifier qu'une action est bien autorisée
     * @param action Action a tester
     */
    void checkAllowedAction( const GenericActionPtr& action ) throw ( std::runtime_error )
    {
        const ActionTypeEnum& type = action->getType();
        if ( type != SubstepingOnErrorType )
            throw std::runtime_error( "Action not allowed" );
    }

public:
    /** @brief Constructeur */
    ResidualDivergenceErrorInstance(): GenericConvergenceErrorInstance( ResidualDivergenceErrorType )
    {};

    ~ResidualDivergenceErrorInstance()
    {};
};

/**
 * @class IncrementOverboundErrorInstance
 * @brief Classe décriant l'événement DELTA_GRANDEUR
 * @author Nicolas Sellenet
 */
class IncrementOverboundErrorInstance: public GenericConvergenceErrorInstance
{
private:
    /** @brief Paramètre VALE_REF */
    GenParam _value;
    /** @brief Paramètre NOM_CHAM */
    GenParam _fieldName;
    /** @brief Paramètre NOM_CMP */
    GenParam _component;

    /**
     * @brief Fonction permettant de vérifier qu'une action est bien autorisée
     * @param action Action a tester
     */
    void checkAllowedAction( const GenericActionPtr& action ) throw ( std::runtime_error )
    {
        const ActionTypeEnum& type = action->getType();
        if ( type != StopOnErrorType && type != SubstepingOnErrorType )
            throw std::runtime_error( "Action not allowed" );
    }

public:
    /** @brief Constructeur */
    IncrementOverboundErrorInstance(): GenericConvergenceErrorInstance( IncrementOverboundErrorType ),
                                       _value( "VALE_REF", true ),
                                       _fieldName( "NOM_CHAM", "", true ),
                                       _component( "NOM_CMP", true )
    {
        _listSyntaxParam.push_back( &_value );
        _listSyntaxParam.push_back( &_fieldName );
        _listSyntaxParam.push_back( &_component );
    };

    ~IncrementOverboundErrorInstance()
    {};

    /**
     * @brief Fixer la valeur à vérifier
     * @param value Valeur de l'incrément
     * @param fieldName Nom du champ
     * @param component Nom de la composante
     */
    void setValueToInspect( const double& value, const std::string& fieldName,
                            const PhysicalQuantityComponent& component )
    {
        _value = value;
        _fieldName.setValue( fieldName );
        _component = ComponentNames[ component ];
    };
};

/**
 * @class ContactDetectionErrorInstance
 * @brief Classe décriant l'événement COLLISION
 * @author Nicolas Sellenet
 */
class ContactDetectionErrorInstance: public GenericConvergenceErrorInstance
{
private:
    /**
     * @brief Fonction permettant de vérifier qu'une action est bien autorisée
     * @param action Action a tester
     */
    void checkAllowedAction( const GenericActionPtr& action ) throw ( std::runtime_error )
    {
        const ActionTypeEnum& type = action->getType();
        if ( type != StopOnErrorType && type != SubstepingOnContactType )
            throw std::runtime_error( "Action not allowed" );
    }

public:
    /** @brief Constructeur */
    ContactDetectionErrorInstance(): GenericConvergenceErrorInstance( ContactDetectionErrorType )
    {};

    ~ContactDetectionErrorInstance()
    {};
};

/**
 * @class InterpenetrationErrorInstance
 * @brief Classe décriant l'événement INTERPENETRATION
 * @author Nicolas Sellenet
 */
class InterpenetrationErrorInstance: public GenericConvergenceErrorInstance
{
private:
    /** @brief Paramètre PENE_MAXI */
    GenParam _maxPenetration;

    /**
     * @brief Fonction permettant de vérifier qu'une action est bien autorisée
     * @param action Action a tester
     */
    void checkAllowedAction( const GenericActionPtr& action ) throw ( std::runtime_error )
    {
        const ActionTypeEnum& type = action->getType();
        if ( type != StopOnErrorType && type != ChangePenalisationOnErrorType )
            throw std::runtime_error( "Action not allowed" );
    }

public:
    /** @brief Constructeur */
    InterpenetrationErrorInstance(): GenericConvergenceErrorInstance( InterpenetrationErrorType ),
                                     _maxPenetration( "PENE_MAXI", true )
    {
        _listSyntaxParam.push_back( &_maxPenetration );
    };

    ~InterpenetrationErrorInstance()
    {};

    /**
     * @brief Fixer la valeur maximale de l'interpénétration
     * @param value Valeur maximale
     */
    void setMaximalPenetration( const double& value )
    {
        _maxPenetration = value;
    };
};

/**
 * @class InstabilityErrorInstance
 * @brief Classe décriant l'événement INSTABILITE
 * @author Nicolas Sellenet
 */
class InstabilityErrorInstance: public GenericConvergenceErrorInstance
{
private:
    /**
     * @brief Fonction permettant de vérifier qu'une action est bien autorisée
     * @param action Action a tester
     */
    void checkAllowedAction( const GenericActionPtr& action ) throw ( std::runtime_error )
    {
        const ActionTypeEnum& type = action->getType();
        if ( type != StopOnErrorType && type != ContinueOnErrorType )
            throw std::runtime_error( "Action not allowed" );
    }

public:
    /**
     * @brief Constructeur
     */
    InstabilityErrorInstance(): GenericConvergenceErrorInstance( InstabilityErrorType )
    {};

    ~InstabilityErrorInstance()
    {};
};


/** @typedef Pointeur intelligent vers un GenericConvergenceErrorInstance */
typedef boost::shared_ptr< GenericConvergenceErrorInstance > GenericConvergenceErrorPtr;
/** @typedef Pointeur intelligent vers un ConvergenceErrorInstance */
typedef boost::shared_ptr< ConvergenceErrorInstance > ConvergenceErrorPtr;
/** @typedef Pointeur intelligent vers un ResidualDivergenceErrorInstance */
typedef boost::shared_ptr< ResidualDivergenceErrorInstance > ResidualDivergenceErrorPtr;
/** @typedef Pointeur intelligent vers un IncrementOverboundErrorInstance */
typedef boost::shared_ptr< IncrementOverboundErrorInstance > IncrementOverboundErrorPtr;
/** @typedef Pointeur intelligent vers un ContactDetectionErrorInstance */
typedef boost::shared_ptr< ContactDetectionErrorInstance > ContactDetectionErrorPtr;
/** @typedef Pointeur intelligent vers un InterpenetrationErrorInstance */
typedef boost::shared_ptr< InterpenetrationErrorInstance > InterpenetrationErrorPtr;
/** @typedef Pointeur intelligent vers un InstabilityErrorInstance */
typedef boost::shared_ptr< InstabilityErrorInstance > InstabilityErrorPtr;


/** @typedef std::list de GenericConvergenceErrorPtr */
typedef std::list< GenericConvergenceErrorPtr > ListConvError;
/** @typedef Iterateur sur une std::list de GenericConvergenceErrorPtr */
typedef ListConvError::iterator ListConvErrorIter;
/** @typedef Iterateur constant sur une std::list de GenericConvergenceErrorPtr */
typedef ListConvError::const_iterator ListConvErrorCIter;

#endif /* FAILURECONVERGENCEMANAGER_H_ */
